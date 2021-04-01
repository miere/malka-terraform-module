FROM miere/malka-consumer:${malka_version}

ADD ./configuration.generated /etc/malka.conf

CMD ["/etc/malka.conf"]