FROM python:3.13-slim-bookworm

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN pip install --no-cache-dir uv
RUN uv sync --frozen

COPY app/ ./app/
COPY db/ ./db/
COPY services.toml ./

RUN mkdir -p ./data
RUN useradd --no-log-init --create-home appuser \
    && chown -R appuser:appuser /app
USER appuser
CMD ["uv", "run", "fastapi", "run", "app/main.py", "--host", "0.0.0.0", "--port", "8000"]
