---
description: "Run ML training jobs (LoRA, Whisper, fine-tuning) on remote RTX 4090 via SSH"
---

# Remote Trainer

Run ML fine-tuning and training jobs on a dedicated Windows 11 machine with an
NVIDIA RTX 4090 (24GB VRAM), accessible via SSH from your Mac.

## Capabilities

- LoRA / QLoRA fine-tuning (PEFT, 4-bit quantization for 7B+ models)
- Whisper fine-tuning (speech recognition)
- Any Python ML training script
- Dataset and code transfer (Mac <-> remote)
- Training monitoring and log reading
- Checkpoint and model retrieval

## Connection & Environment

| Property | Value |
|----------|-------|
| SSH alias | `ob-trainer` (key auth configured) |
| OS | Windows 11 |
| CPU | Intel i9-13900KF |
| GPU | NVIDIA RTX 4090 24GB |
| RAM | 96GB |
| Python | 3.11 (in venv) |
| Venv | `C:\trainer\venv` |
| Workspace | `C:\trainer` |

### Workspace Layout

```
C:\trainer\
  data\       # Datasets
  repos\      # Cloned repositories
  runs\       # Training outputs, checkpoints
  logs\       # Job logs (auto-created by runner)
  scripts\    # Runner script and utilities
  venv\       # Python 3.11 virtual environment
```

### Runner Script

All commands go through the runner at `C:\trainer\scripts\run-job.ps1`.
It activates the venv, sets working directory to `C:\trainer`, logs
stdout/stderr to `C:\trainer\logs\job-YYYYMMDD-HHMMSS.log`, and
returns the command's exit code.

**Pattern:**
```bash
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "<command>"'
```

## Command Reference

### Health Check

```bash
# Python version
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python --version"'

# Torch + CUDA
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python -c \"import torch; print(torch.__version__); print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0))\""'

# GPU memory
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python -c \"import torch; p=torch.cuda.get_device_properties(0); print(f'"'"'GPU: {torch.cuda.get_device_name(0)}'"'"'); print(f'"'"'VRAM: {p.total_mem/1024**3:.1f} GB'"'"'); print(f'"'"'CUDA: {torch.version.cuda}'"'"')\""'

# Installed packages
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "pip show torch transformers accelerate peft"'
```

### File Transfer

```bash
# Upload dataset to remote
scp -r ./my-dataset ob-trainer:'C:\trainer\data\my-dataset'

# Upload a single file
scp ./train.py ob-trainer:'C:\trainer\scripts\train.py'

# Download checkpoint from remote
scp -r ob-trainer:'C:\trainer\runs\my-project\checkpoint-best' ./local-output/

# Download a trained model
scp -r ob-trainer:'C:\trainer\runs\my-project\final-model' ./models/
```

### Repository Management

```bash
# Clone a repo
ssh ob-trainer 'powershell -Command "cd C:\trainer\repos; git clone <url>"'

# Pull latest
ssh ob-trainer 'powershell -Command "cd C:\trainer\repos\<project>; git pull"'

# List repos
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\repos | Format-Table Name,LastWriteTime -AutoSize"'
```

### Package Management

```bash
# Install packages
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "pip install transformers peft accelerate bitsandbytes datasets"'

# Check what's installed
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "pip list | findstr -i \"torch transformers peft accelerate\""'
```

### Run Training

```bash
# Run a training script
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python C:\trainer\repos\<project>\train.py --config C:\trainer\repos\<project>\config.yaml"'

# Run with specific args
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python C:\trainer\scripts\train.py --model_name meta-llama/Llama-2-7b-hf --dataset C:\trainer\data\my-data --output_dir C:\trainer\runs\my-run --num_epochs 3 --bf16 --gradient_checkpointing"'
```

### Monitoring

```bash
# List recent logs
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\logs | Sort-Object LastWriteTime -Descending | Select-Object -First 10 | Format-Table Name,LastWriteTime,Length -AutoSize"'

# Read latest log (last 100 lines)
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\logs | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content -Tail 100"'

# Read a specific log
ssh ob-trainer 'powershell -Command "Get-Content C:\trainer\logs\job-20260326-143000.log -Tail 50"'

# Check if a training job is running
ssh ob-trainer 'powershell -Command "Get-Process python -ErrorAction SilentlyContinue | Format-Table Id,CPU,WorkingSet64 -AutoSize"'

# Check GPU utilization (nvidia-smi)
ssh ob-trainer 'powershell -Command "nvidia-smi"'

# List checkpoints in a run
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\runs\<project> -Directory | Sort-Object Name | Format-Table Name,LastWriteTime -AutoSize"'
```

## Workflow Templates

### A. LoRA Fine-Tuning

```bash
# 1. Install dependencies
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "pip install transformers peft accelerate bitsandbytes datasets trl"'

# 2. Upload dataset
scp -r ./training-data ob-trainer:'C:\trainer\data\my-lora-project'

# 3. Upload training script
scp ./lora_train.py ob-trainer:'C:\trainer\scripts\lora_train.py'

# 4. Run training
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python C:\trainer\scripts\lora_train.py --model_name <base-model> --dataset_path C:\trainer\data\my-lora-project --output_dir C:\trainer\runs\my-lora-project --num_train_epochs 3 --per_device_train_batch_size 4 --gradient_accumulation_steps 4 --learning_rate 2e-4 --bf16 --gradient_checkpointing --lora_r 16 --lora_alpha 32"'

# 5. Monitor progress
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\logs | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content -Tail 50"'

# 6. Download result
scp -r ob-trainer:'C:\trainer\runs\my-lora-project\checkpoint-best' ./my-lora-adapter/
```

### B. Whisper Fine-Tuning

```bash
# 1. Install Whisper dependencies
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "pip install openai-whisper transformers datasets librosa soundfile jiwer"'

# 2. Upload audio dataset
scp -r ./whisper-data ob-trainer:'C:\trainer\data\whisper-project'

# 3. Upload training script
scp ./whisper_finetune.py ob-trainer:'C:\trainer\scripts\whisper_finetune.py'

# 4. Run training
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python C:\trainer\scripts\whisper_finetune.py --model_name openai/whisper-small --dataset_path C:\trainer\data\whisper-project --output_dir C:\trainer\runs\whisper-project --num_train_epochs 5 --per_device_train_batch_size 8 --bf16 --gradient_checkpointing"'

# 5. Download model
scp -r ob-trainer:'C:\trainer\runs\whisper-project\final-model' ./whisper-finetuned/
```

### C. Custom Script

```bash
# 1. Write script locally, upload it
scp ./my_script.py ob-trainer:'C:\trainer\scripts\my_script.py'

# 2. Run it
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python C:\trainer\scripts\my_script.py --arg1 value1"'

# 3. Check results
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\logs | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content -Tail 100"'
```

## Best Practices

1. **Always use the runner script** — it handles venv activation, logging, and clean exit codes
2. **Organize by project** — `data/<project>`, `runs/<project>`, `repos/<project>`
3. **Enable checkpointing** — for any job >30 minutes, save checkpoints so you can resume
4. **Use `--bf16`** — the RTX 4090 (Ada Lovelace) has excellent BF16 performance
5. **Use `--gradient_checkpointing`** — trades compute for VRAM, essential for larger models
6. **Use QLoRA (4-bit)** — for 7B+ parameter models to fit in 24GB VRAM
7. **Batch size guidance** — start with batch_size=4, use gradient_accumulation to increase effective batch
8. **Check GPU before starting** — run `nvidia-smi` to ensure no other jobs are using VRAM

### VRAM Budget (24GB RTX 4090)

| Model Size | Full Fine-Tune | LoRA (16-bit) | QLoRA (4-bit) |
|------------|---------------|---------------|---------------|
| 1-3B | Yes | Yes | Yes |
| 7B | No | Tight (bs=1-2) | Yes (bs=4-8) |
| 13B | No | No | Tight (bs=1-2) |
| 30B+ | No | No | No |

## Constraints

- **Single GPU** — no multi-GPU / distributed training
- **24GB VRAM** — use QLoRA for 7B+ models, gradient checkpointing always
- **Windows paths** — use backslashes in remote paths
- **Quote escaping** — SSH -> PowerShell -> Python requires careful nested quoting
- **Long jobs** — SSH may timeout; the runner logs everything so you can check results after disconnect
- **No GUI** — headless SSH only; no Jupyter, no TensorBoard (use logs + metrics files)

## Troubleshooting

### CUDA Out of Memory
```bash
# Reduce batch size, enable gradient checkpointing, use 4-bit quantization
--per_device_train_batch_size 1 --gradient_checkpointing --load_in_4bit
```

### SSH Connection Reset
The runner script logs everything to `C:\trainer\logs\`. Even if SSH drops,
the job continues and you can read the log after:
```bash
ssh ob-trainer 'powershell -Command "Get-ChildItem C:\trainer\logs | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content -Tail 200"'
```

### Kill a Stuck Job
```bash
ssh ob-trainer 'powershell -Command "Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force; Write-Host Done"'
```

### PowerShell Quoting Issues
For complex Python one-liners, write a small `.py` file and upload it instead
of trying to escape everything inline:
```bash
echo 'import torch; print(torch.cuda.memory_summary())' > /tmp/check.py
scp /tmp/check.py ob-trainer:'C:\trainer\scripts\check.py'
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python C:\trainer\scripts\check.py"'
```

### Verify Environment is Working
```bash
ssh ob-trainer 'powershell -ExecutionPolicy Bypass -File C:\trainer\scripts\run-job.ps1 -Command "python -c \"import torch; assert torch.cuda.is_available(), '"'"'No CUDA'"'"'; print(f'"'"'OK: {torch.cuda.get_device_name(0)}, VRAM: {torch.cuda.get_device_properties(0).total_mem/1024**3:.0f}GB'"'"')\""'
```
