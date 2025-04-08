## 使用 Docker Compose 部署 OpenVPN

以 `kylemanna/openvpn` 镜像为例，快速部署 OpenVPN。

---

### 一、创建项目目录
```bash
mkdir -p ~/openvpn && cd ~/openvpn
```

---

### 二、创建 `docker-compose.yml`
```yaml
version: '3.8'

services:
  openvpn:
    image: kylemanna/openvpn
    container_name: openvpn
    restart: always
    cap_add:
      - NET_ADMIN
    ports:
      - "1194:1194/udp"
    volumes:
      - ./ovpn-data:/etc/openvpn
    environment:
      - TZ=Asia/Shanghai
```

---

### 三、初始化配置
```bash
docker-compose run --rm openvpn ovpn_genconfig -u udp://your.domain.com
docker-compose run --rm openvpn ovpn_initpki
```
使用公网 IP 时可替换 `your.domain.com` 为真实 IP。

---

### 四、启动服务
```bash
docker-compose up -d
```

---

### 五、添加客户端证书
```bash
docker-compose run --rm openvpn easyrsa build-client-full client1 nopass
docker-compose run --rm openvpn ovpn_getclient client1 > client1.ovpn
```
将 `client1.ovpn` 下载至本地导入 OpenVPN 客户端使用。

---

### 六、开放防火墙与转发（以 CentOS 7 为例）
```bash
firewall-cmd --add-port=1194/udp --permanent
firewall-cmd --reload

# 开启转发
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
```

---

### 七、查看运行日志
```bash
docker logs openvpn
```

---

### 完成！你现在可以使用客户端连接该 OpenVPN 服务器了。

如需添加 Web UI 或更多高级配置，可基于此镜像拓展。

