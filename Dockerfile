FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git curl ripgrep ffmpeg nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app
COPY . .

RUN git submodule update --init mini-swe-agent

RUN uv venv venv --python 3.11
ENV VIRTUAL_ENV=/app/venv
RUN uv pip install -e ".[all]"
RUN uv pip install -e "./mini-swe-agent"

CMD ["bash", "scripts/entrypoint.sh"]
