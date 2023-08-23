需要在域名解析的服务器上执行，因为external-ip 需要CPI 提供，在没有CPI时，需要通过端口转发来提供.
kubectl port-forward --address 0.0.0.0 --namespace=ingress-nginx service/ingress-nginx-controller 9000:80  &


如果使用caddy server 作为请求前端，反向代理到后端地址，请使用如下配置：
```
{   
	#auto_https off 
}

*.in.dxids.com in.dxids.com {
        tls 676982376@qq.com {
                dns alidns {
                  access_key_id {env.ALIYUN_ACCESS_KEY_ID}
                  access_key_secret {env.ALIYUN_ACCESS_KEY_SECRET}
                }
                resolvers ns1.alidns.com
        }
        @websockets {
                header Connection *Upgrade*
                header Upgrade    websocket
        }

        @in host *.in.dxids.com
        handle @in {
                reverse_proxy :9000 {
                        header_up Host {host}:9000
                } 
                reverse_proxy @websockets :9000 
        }       
}

```