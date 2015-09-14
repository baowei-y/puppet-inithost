# inithost

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with inithost](#setup)
    * [What inithost affects](#what-inithost-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with inithost](#beginning-with-inithost)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

  系统初始化模块

## Module Description

  配置系统初始化，功能如下：
```
  1、系统语言环境
  2、时区
  3、源、源代理
  4、基础依赖包
  5、selinux(redhat/centos)
  6、控制一个非root的超级用户
  7、一些命令别名的下发
  8、ulimit的nofile和noproc配置
```

## Setup

### What inithost affects
  具体变更根据用户传递的参数决定  

### Setup Requirements **OPTIONAL**

```
1、由于文件类资源在修改时会在文件所在的当前目录做备份，备份所用格式调用自定义facter变量: backup_data(stdlib/lib/facter/backup_date.rb)"，此fact由于考虑在其它情况会大量用到，因此放入stdlib库中.
2、redhat/centos系统在识别系统大版本是，facter变量$::lsbmajdistrelease依赖于redhat-lsb包的安装，因此在未安装的情况下facter则无法识别系统大版本号，由于依赖关系，系统大版本号的识别单独写了一个简单的fact,放在(stdlib/lib/facter/priosrelease.rb)
3、需要agent端开启插件同步功能
4、配置ulimit时，由于debian系列仅配置/etc/security/limit.conf不生效，因此debian系列的系统在/etc/profile.d/中添加一个ulimit.sh文件，以命令的形式执行生效.

```

### Beginning with inithost

#### 例: 简单使用初始化模块，需求如下
```
  1、设置系统语言为en_US.UTF-8
  2、设置系统时区为Asia/Shanghai
  3、配置基础源指向 mirrors.aliyun.com
  4、安装基础工具包
  5、下发初始化命令别名
  6、配置一个免密码的sudo用户admin，其密码为Ab654890
  7、如果是redhat系列，则关闭selinux
```
#### Usage
```
node 'node1.bw-y.com' {
  class { '::inithost':
    base_lang        => 'en_US.UTF-8',
    base_timezone    => 'Asia/Shanghai',
    base_source      => 'present',
    base_package     => true,
    source_url       => 'mirrors.aliyun.com',
    superuser_ensure => 'present',
    superuser_name   => 'admin',
    superuser_pass   => '$1$sTiwpocZ$owSvS2fCDCcP5xDdldJXM/',
    selinux_status   => 'disabled',
  }
}
```

## Reference
### Classes

#### Public Classes

* inithost: Main class, includes all other classes.

#### Private Classes

* inithost::files: Handles the files.
* inithost::oslang: Handles the Operating System Language.
* inithost::exec: Handles the command.
* inithost::source: Handles the Software Sources.
* inithost::packages: Handles the packages.
* inithost::superuser: Handles the a custom super user.

### Parameters

The following parameters are available in the `::inithost` class:

#### `base_lang`

```
这是系统语言环境变量，为空则不做修改；有效参数如： en_US.UTF-8    默认值: 空
```

#### `base_timezone`

```
设置系统时区, 有效参数如：Asia/Shanghai ; 需要注意的是，此参数会和/usr/share/zoneinfo拼接起来，
以软连接的方式指向 /etc/localtime， 同时debian系列，会将此值写入 /etc/timezone ; 默认值：Asia/Shanghai
```

#### `base_package`

```
安装系统初始化依赖包，推荐初始新节点时设置;   默认值： false
```

#### `base_source`

```
设置系统源，可支持系统如下：
ubuntu12.04/14.04、rhel/centos(5/6) 
其中rhel/centos系列还会配置epel源
此参数用来控制三个和源相关的操作，如下：
  present : 安装源，并配置源指向参数 `source_url`
  absent  : 删除源，rhel/centos会删除epel包
  ignore  : 默认值， 不对当前节点源做任何操作
```

#### `source_url`

```
设置系统源的url地址,仅给出域名即可；
但需要域名所提供的源符合阿里源或网易源的目录结构
此参数依赖$base_source; 默认值： mirrors.aliyun.com
```

#### `source_proxy`

```
如果需要给源配置某个http代理，需要给出完整url路径+端口，如: http://10.0.0.20:3218
此参数为空时不设置代理，目前仅支持 `http://ip_or_fqdn:port` 这种格式   默认值： 空
```

#### `selinux_status`

```
配置centos/rhel的selinux
有效值如下:
  permissive  :  临时关闭selinux
  enforcing   :  开启selinux
  disabled    :  关闭selinux，并写入配置文件, 默认值
```

#### `superuser_ensure`

```
设置非root的超级用户状态，
此用户可以免密码切换到root( sudo -i )
有效值如下:
  present  :  如果不存在，则创建
  absent   :  默认值，  如果存在，则删除 
```

#### `superuser_name`

```
设置非root的超级用户名字,有效值需匹配linux系统用户命名规则.    默认值: xx00
```

#### `superuser_pass`

```
设置非root的超级用户密码
有效值参考`*unix`的root密码`(cat /etc/shadow|grep root|awk -F: '{print $2}')`
默认值(`123456`): `$6$PHKSLyZj$8/fdMec3l3TpWpfQM.ji4h5P2wnUv9o.rIC8vHOyNeCR9Qrab6Cbmoaq1qtFiogGofNKlwWTaj1I48j1isF7m/`
```

#### `init_env_ensure`

```
设置初始化下发的/etc/profile.d/bw-y-env.sh是否启用，有效值如下
  present : 默认值， 如果不存在，则创建
  absent  : 如果存在，则删除
```

#### `ulimit_nofile`

```
设置ulimit nofile值，有效值类型为正整数； 默认值：1048576
```

#### `ulimit_noproc`

```
设置ulimit noproc值，有效值类型为正整数； 默认值：1048576
```

### `stage`
```
执行顺序，见stdlib::stages
```
## Limitations

目前仅支持系统如下：rhel/centos(5/6) , ubuntu(10.04/12.04/14.04)
