# WikiSum
Docker image and extra documentation for WikiSum.

# Requirements
- NVIDIA GPU
- Latest [NVIDIA drivers](https://www.nvidia.com/Download/index.aspx?lang=en-us)
- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

# Installation
You can either pull a [prebuilt image](https://hub.docker.com/r/stepgazaille/wikisum)  from DockerHub or build the image using the provided DockerFile.
## Pull image from DockerHub
```
docker pull stepgazaille/wikisum:0.0.1
```
## Build image using DockerFile
```
cd wikisum
docker build -t stepgazaille/wikisum:0.0.1 .
```

# Usage
Assuming this repository was cloned to `~/wikisum` on your local host, the following command will:
- Launch a container based on the `stepgazaille/wikisum:0.0.1` docker image
- Mount the local `~/wikisum` directory to the container's `/home/wikisum` directory
- Publish the container's `6006` port to the host (allow using Tensorboard from the local host's browser)
- Provide an interactive terminal to the container
```
docker run --runtime=nvidia -u $(id -u):$(id -g) -it --rm -v $(realpath ~/wikisum):/home/wikisum -p 6006:6006 stepgazaille/wikisum:0.0.1 /bin/bash
```
All commands below should be executed from within the running container.

## Download CNN/DailyMail corpus
```
t2t-datagen \
  --data_dir=data \
  --tmp_dir=/tmp/t2t_datagen \
  --problem=summarize_cnn_dailymail32k
```

## Train transformer_base model
```
t2t-trainer \
  --problem=summarize_cnn_dailymail32k \
  --model=transformer \
  --hparams_set=transformer_base \
  --train_steps=250000 \
  --eval_steps=100 \
  --data_dir=data \
  --output_dir=output
```


## Evaluate transformer_base model
```
t2t-decoder \
  --problem=summarize_cnn_dailymail32k \
  --model=transformer \
  --hparams_set=transformer_base \
  --data_dir=data \
  --output_dir=output \
  --decode_hparams="beam_size=4,alpha=0.6" \
  --schedule=eval
```

## Decode using the transformer_base model
```
t2t-decoder \
  --problem=summarize_cnn_dailymail32k \
  --model=transformer \
  --hparams_set=transformer_base \
  --data_dir=data \
  --output_dir=output \
  --decode_hparams="beam_size=4,alpha=0.6" \
  --decode_from_file=decode_this.txt \
  --decode_to_file=summary.txt
```

# Tensorboard
Use the following command to launch Tensorboard from the container:
```
tensorboard --logdir output
```
Tensorboard can be accessed on the local host at [http://localhost:6006](http://localhost:6006)
