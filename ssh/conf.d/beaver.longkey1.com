Host beaver.longkey1.com
  ProxyCommand cloudflared access ssh --hostname %h
