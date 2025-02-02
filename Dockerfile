FROM golang:1.13 AS build
ADD . /src
WORKDIR /src
#ENV HTTP_PROXY="http://10.60.46.250:3128" 
#ENV HTTPS_PROXY="http://10.60.46.250:3128"
RUN go get -d -v -t
RUN go test --cover -v ./... --run UnitTest
RUN go build -v -o go-demo



FROM alpine:3.4
MAINTAINER 	Viktor Farcic <viktor@farcic.com>

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

EXPOSE 8080
ENV DB db
CMD ["go-demo"]

COPY --from=build /src/go-demo /usr/local/bin/go-demo
RUN chmod +x /usr/local/bin/go-demo
#ENV HTTP_PROXY="" 
#ENV HTTPS_PROXY=""
