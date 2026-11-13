# myip

A small shell script that prints your public IP address. It can also stay quiet unless the address has changed,
which is handy in cron jobs that update a firewall rule, a DNS record or a notification.

```sh
myip              # 203.0.113.7
myip -6           # 2001:db8::1c (if your connection has IPv6)
myip --changed    # prints the address only when it differs from the last run
```

It needs `curl` and a POSIX shell, so it runs as is on macOS, Linux and WSL.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/Ishant-Singh-Dev/myip/main/myip.sh -o ~/.local/bin/myip
chmod +x ~/.local/bin/myip
```

The script is short. Read it before you run it.

## How it works

The script calls `https://ipcomet.com/api/ip`, which replies with your address as one line of plain text. The
[ipcomet API page](https://ipcomet.com/developers) lists the other endpoints, including `/api/me` for location,
ASN and network owner as JSON. None of them needs a key.

`--changed` keeps the last address in `~/.myip-4` or `~/.myip-6`. The IP version is fixed on purpose: on a
dual-stack connection curl can reach a server over IPv4 on one run and IPv6 on the next, and comparing those two
answers would report a change every time.

## Use it in cron

```sh
*/10 * * * * ip=$(~/.local/bin/myip --changed) && [ -n "$ip" ] && echo "$(date) $ip" >> ~/ip-changes.log
```

Replace the `echo` with whatever should happen when the address changes.

## Without the script

```sh
curl https://ipcomet.com          # plain text for curl and wget, the web page for browsers
curl https://ipcomet.com/api/ip   # always plain text
curl https://ipcomet.com/api/me   # JSON with location and network details
```

## Privacy

ipcomet says its own code does not store the addresses it sees. Any service you call still receives your IP
address, because that is how the request reaches it.

## License

MIT
