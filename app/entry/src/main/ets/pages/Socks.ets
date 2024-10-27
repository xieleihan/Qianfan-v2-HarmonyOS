import { vpnExtension } from '@kit.NetworkKit';
import MyNavigation from '../components/MyNavigation'
import router from '@ohos.router'
import vpnext from '@ohos.net.vpnExtension';
import { BusinessError } from '@kit.BasicServicesKit';
import { showToast } from '../components/ShowToast';
import Want from '@ohos.app.ability.Want';

import common from '@ohos.app.ability.common';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 定义一个路由传参类
class routerParam{
  text: string

  constructor(value:string) {
    this.text = value
  }
}

let params = router.getParams() as routerParam

let g_tunFd = -1;
let g_tunnelFd = -1;

@Entry
@Component

struct Socks{
  // CreateTunnel() {
  //   g_tunnelFd = vpn_client.tcpConnect(this.vpnServerIp, 8888);
  //   if (g_tunnelFd) {
  //     showToast('CreateTunnel Success', 2000);
  //     hilog.info(0x0000, 'developTag', '%{public}s', 'CreateTunnel Success');
  //   } else {
  //     showToast('CreateTunnel Fail', 2000);
  //     hilog.error(0x0000, 'developTag', 'CreateTunnel Fail %{public}s', 'CreateTunnel Fail');
  //   }
  // }
  //
  // Protect() {
  //   hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Protect');
  //   this.VpnConnection.protect(g_tunnelFd).then(() => {
  //     showToast('vpn Protect Success', 2000);
  //     hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Protect Success');
  //   }).catch((err: Error) => {
  //     showToast('vpn Protect Failed: ' + JSON.stringify(err), 2000);
  //     hilog.error(0x0000, 'developTag', 'vpn Protect Failed %{public}s', JSON.stringify(err) ?? '');
  //   })
  // }
  //
  // SetupVpn() {
  //   hilog.info(0x0000, 'developTag', '%{public}s', 'vpn SetupVpn');
  //   class Address {
  //     address: string;
  //     family: number;
  //
  //     constructor(address: string, family: number) {
  //       this.address = address;
  //       this.family = family;
  //     }
  //   }
  //
  //   class AddressWithPrefix {
  //     address: Address;
  //     prefixLength: number;
  //
  //     constructor(address: Address, prefixLength: number) {
  //       this.address = address;
  //       this.prefixLength = prefixLength;
  //     }
  //   }
  //
  //   class Config {
  //     addresses: AddressWithPrefix[];
  //     mtu: number;
  //     dnsAddresses: string[];
  //     trustedApplications: string[];
  //     blockedApplications: string[];
  //
  //     constructor(
  //       tunIp: string,
  //       blockedAppName: string
  //     ) {
  //       this.addresses = [
  //         new AddressWithPrefix(new Address(tunIp, 1), 24)
  //       ];
  //       this.mtu = 1400;
  //       this.dnsAddresses = ["114.114.114.114"];
  //       this.trustedApplications = [];
  //       this.blockedApplications = [blockedAppName];
  //     }
  //   }
  //
  //   let config = new Config(this.tunIp, this.blockedAppName);
  //   this.VpnConnection.create(config).then((data) => {
  //     g_tunFd = data;
  //     hilog.error(0x0000, 'developTag', 'tunfd: %{public}s', JSON.stringify(data) ?? '');
  //     vpn_client.startVpn(g_tunFd, g_tunnelFd);
  //     showToast('vpn start Success', 2000);
  //     hilog.info(0x0000, 'developTag', '%{public}s', 'vpn start Success');
  //   }).catch((err: BusinessError) => {
  //     showToast('vpn start Fail: ' + JSON.stringify(err), 2000);
  //     hilog.error(0x0000, 'developTag', 'vpn start Fail %{public}s', JSON.stringify(err) ?? '');
  //   })
  // }

  @State message: string = 'Toy VPN';
  @State vpnServerIp: string = '192.168.31.13';
  @State tunIp: string = '10.0.0.5';
  @State prefix: string = '24';
  @State blockedAppName: string = 'com.example.baidumyapplication';
  private context = getContext(this) as common.VpnExtensionContext;
  private VpnConnection: vpnext.VpnConnection = vpnext.createVpnConnection(this.context);

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Client');
          })

        Row() {
          //ip address of server
          Text('server ip').fontSize(30).width('40%').textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE)
          TextInput({ text: '192.168.31.13' }).onChange((value) => {
            this.vpnServerIp = value;
          }).width('60%').margin(2)
        }.width('90%')

        Row() {
          //ip address of tun-vpn on server
          Text('tun ip').fontSize(30).width('40%').textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE)
          TextInput({ text: '10.0.0.5' }).onChange((value) => {
            this.tunIp = value;
          }).width('60%').margin(2)
        }.width('90%')

        Row() {
          //blocked Hap
          Text('blockedApp').fontSize(30).width('40%').textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE)
          TextInput({ text: 'com.example.baidumyapplication' }).onChange((value) => {
            this.blockedAppName = value;
          }).width('60%').margin(2)
        }.width('90%')

        Button("创建隧道").onClick(() => {
          // this.CreateTunnel();
          console.log("创建隧道")
        }).fontSize(50)
        Button("隧道保护").onClick(() => {
          // this.Protect();
          console.log("隧道保护")
        }).fontSize(50)
        Button("启动vpn").onClick(() => {
          // this.SetupVpn();
          console.log("启动vpn")
        }).fontSize(50)
        Button("启动vpnExt").onClick(() => {
          // try {
          //   vpnext.startVpnExtensionAbility(Want).then(() => {
          //     showToast('start vpnExt Success', 2000);
          //     hilog.info(0x0000, 'developTag', '%{public}s', 'start vpnExt Success');
          //   })
          // } catch (err) {
          //   showToast('start vpnExt Fail: ' + JSON.stringify(err), 2000);
          //   hilog.error(0x0000, 'developTag', 'start vpnExt Fail %{public}s', JSON.stringify(err) ?? '');
          // }
          console.log("启动vpnExt")
        }).fontSize(50)
      }
      .width('100%')
    }
    .height('100%')
  }
}