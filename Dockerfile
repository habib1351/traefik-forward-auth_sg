FROM golang:1.13-alpine as builder

# Setup
RUN mkdir -p /go/src/github.com/habib1351/traefik-forward-auth_sg
WORKDIR /go/src/github.com/habib1351/traefik-forward-auth_sg

# Add libraries
RUN apk add --no-cache git

# Copy & build
ADD . /go/src/github.com/habib1351/traefik-forward-auth_sg
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -installsuffix nocgo -o /traefik-forward-auth_sg github.com/habib1351/traefik-forward-auth_sg/cmd

# Copy into scratch container
FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /traefik-forward-auth_sg ./
ENTRYPOINT ["./traefik-forward-auth"]
