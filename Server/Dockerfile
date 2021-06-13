FROM python:3.9-slim
COPY . .
RUN pip install -r requirements.txt
RUN useradd -ms /bin/bash admin
RUN chown -R admin output.glb
USER admin
CMD ["python", "app/app.py"]