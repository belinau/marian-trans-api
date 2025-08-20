# Use a base image with Python and common build tools
FROM python:3.9-slim-bullseye

# Install system dependencies required for ML libraries and Rust
# This includes build-essential for C/C++ compilation, and curl for rustup
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Rust toolchain using rustup
# This assumes you need Rust for some part of your project or its dependencies
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY . .

# Expose the port your FastAPI app will run on
# Render will inject the PORT environment variable, so your app should listen on it
EXPOSE 8000

# Command to run your FastAPI application with Uvicorn
# Ensure your app listens on 0.0.0.0 and the PORT environment variable
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "$PORT"]