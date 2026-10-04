FROM python:3.11-slim
WORKDIR /app

# curl for the model download script
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ ./backend/
COPY web/ ./web/
COPY data/ ./data/
COPY demo_assets/ ./demo_assets/
COPY download_models.sh .
RUN mkdir -p models && bash download_models.sh && ls -la models/

# Railway injects $PORT; default 7860 for local runs
CMD ["sh", "-c", "python3 -m uvicorn backend.app:app --host 0.0.0.0 --port ${PORT:-7860}"]
