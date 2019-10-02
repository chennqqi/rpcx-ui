FROM golang:1.13.1 as builder
COPY . /go/src/github.com/chennqqi/rpcx-ui
WORKDIR /go/src/github.com/chennqqi/rpcx-ui
#ENV GOPROXY=https://goproxy.cn

# build
RUN CGO_ENABLED=0 GOOS=linux go build --ldflags "-s -w" -a -installsuffix cgo -o /go/src/app/buildtarget

#FROM scratch
FROM alpine

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirror.tuna.tsinghua.edu.cn/g' /etc/apk/repositories 
RUN apk add --no-cache ca-certificates

COPY --from=builder /go/src/app/buildtarget /app/rpcx-ui
COPY templates /app/templates
COPY web /app/web

#COPY config.json /app/config.json
RUN addgroup -S app && adduser -S -g app app \
	&& chown app:app -R /app
	
USER app
WORKDIR /app

EXPOSE 8972
CMD [ "rpcx-ui" ]
