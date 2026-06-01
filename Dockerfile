FROM docker.ll3006.it/jidouteki:dev AS base

RUN mkdir -p /app/lib/parsers
ENV PARSERS_DIR=/app/lib/parsers

FROM base AS app
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY src src

FROM app AS dev
CMD  ["flask", "--app", "src:app", "run", "--host", "0.0.0.0", "-p", "8080", "--debug"]

FROM app AS prod
CMD ["hypercorn", "--bind", "0.0.0.0:8080", "src:app"]

EXPOSE 8080