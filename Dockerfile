FROM python:3.7-buster as builder

WORKDIR /app

RUN pip install -U pip

COPY requirements.txt /app

RUN pip install -r requirements.txt

FROM python:3.7-slim-buster as runner

COPY --from=builder /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages
COPY --from=builder /usr/local/bin/streamlit /usr/local/bin/streamlit
COPY --from=builder /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu

ENV PATH $PATH:/usr/local/bin/streamlit

WORKDIR /app

USER root

CMD streamlit run app.py

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN mkdir -p /root/.streamlit
RUN bash -c 'echo -e "\
            [general]\n\
            email = \"\"\n\
            " > /root/.streamlit/credentials.toml'

RUN bash -c 'echo -e "\
            [server]\n\
            enableCORS = false\n\
            " > /root/.streamlit/config.toml'