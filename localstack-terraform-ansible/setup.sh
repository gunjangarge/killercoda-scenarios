mkdir /tmp/setup ~/.aws

# install misc 
apt-get update -y && sudo apt-get install -y gnupg software-properties-common

# install k3s
curl -sfL https://get.k3s.io | sh -

# install vscode
export DEBIAN_FRONTEND=noninteractive
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt install -y ./vscode.deb

# install terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update -y
apt-get install terraform -y

# install ansible
python3 -m pip install --user ansible
sudo apt install ansible -y

# run localstack
docker run -d --name=localstack -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack

# copy localstack terraform provider
mkdir -p /opt/terraform
cat <<EOF >/opt/terraform/provider.tf
provider "aws" {
  region                      = "eu-west-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true


  endpoints {
    acm                      = "http://localhost:4566"
    amplify                  = "http://localhost:4566"
    apigateway               = "http://localhost:4566"
    apigatewayv2             = "http://localhost:4566"
    appconfig                = "http://localhost:4566"
    applicationautoscaling   = "http://localhost:4566"
    appsync                  = "http://localhost:4566"
    athena                   = "http://localhost:4566"
    autoscaling              = "http://localhost:4566"
    backup                   = "http://localhost:4566"
    batch                    = "http://localhost:4566"
    cloudformation           = "http://localhost:4566"
    cloudfront               = "http://localhost:4566"
    cloudsearch              = "http://localhost:4566"
    cloudtrail               = "http://localhost:4566"
    cloudwatch               = "http://localhost:4566"
    cloudwatchlogs           = "http://localhost:4566"
    codecommit               = "http://localhost:4566"
    cognitoidentity          = "http://localhost:4566"
    cognitoidp               = "http://localhost:4566"
    config                   = "http://localhost:4566"
    configservice            = "http://localhost:4566"
    costexplorer             = "http://localhost:4566"
    docdb                    = "http://localhost:4566"
    dynamodb                 = "http://localhost:4566"
    dynamodbstreams          = "http://localhost:4566"
    ec2                      = "http://localhost:4566"
    ecr                      = "http://localhost:4566"
    ecs                      = "http://localhost:4566"
    efs                      = "http://localhost:4566"
    eks                      = "http://localhost:4566"
    elasticache              = "http://localhost:4566"
    elasticbeanstalk         = "http://localhost:4566"
    elasticsearch            = "http://localhost:4566"
    elb                      = "http://localhost:4566"
    elbv2                    = "http://localhost:4566"
    emr                      = "http://localhost:4566"
    es                       = "http://localhost:4566"
    events                   = "http://localhost:4566"
    firehose                 = "http://localhost:4566"
    glacier                  = "http://localhost:4566"
    glue                     = "http://localhost:4566"
    iam                      = "http://localhost:4566"
    iot                      = "http://localhost:4566"
    iotanalytics             = "http://localhost:4566"
    iotevents                = "http://localhost:4566"
    ioteventsdata            = "http://localhost:4566"
    iotwireless              = "http://localhost:4566"
    kafka                    = "http://localhost:4566"
    kinesis                  = "http://localhost:4566"
    kinesisanalytics         = "http://localhost:4566"
    kinesisanalyticsv2       = "http://localhost:4566"
    kms                      = "http://localhost:4566"
    lakeformation            = "http://localhost:4566"
    lambda                   = "http://localhost:4566"
    mediaconvert             = "http://localhost:4566"
    mediastore               = "http://localhost:4566"
    mediastoredata           = "http://localhost:4566"
    neptune                  = "http://localhost:4566"
    organizations            = "http://localhost:4566"
    qldb                     = "http://localhost:4566"
    qldbsession              = "http://localhost:4566"
    rds                      = "http://localhost:4566"
    rdsdata                  = "http://localhost:4566"
    redshift                 = "http://localhost:4566"
    redshiftdata             = "http://localhost:4566"
    resourcegroups           = "http://localhost:4566"
    resourcegroupstaggingapi = "http://localhost:4566"
    route53                  = "http://localhost:4566"
    route53resolver          = "http://localhost:4566"
    s3                       = "http://s3.localhost.localstack.cloud:4566"
    s3control                = "http://localhost:4566"
    sagemaker                = "http://localhost:4566"
    sagemakerruntime         = "http://localhost:4566"
    secretsmanager           = "http://localhost:4566"
    serverlessrepo           = "http://localhost:4566"
    servicediscovery         = "http://localhost:4566"
    ses                      = "http://localhost:4566"
    sesv2                    = "http://localhost:4566"
    sns                      = "http://localhost:4566"
    sqs                      = "http://localhost:4566"
    ssm                      = "http://localhost:4566"
    stepfunctions            = "http://localhost:4566"
    sts                      = "http://localhost:4566"
    support                  = "http://localhost:4566"
    swf                      = "http://localhost:4566"
    timestreamquery          = "http://localhost:4566"
    timestreamwrite          = "http://localhost:4566"
    transfer                 = "http://localhost:4566"
    waf                      = "http://localhost:4566"
    wafv2                    = "http://localhost:4566"
    xray                     = "http://localhost:4566"
  }

  default_tags {
    tags = {
      Environment = "Local"
      Service     = "LocalStack"
    }
  }
}
EOF

cp /opt/terraform/provider.tf /tmp/setup/provider.tf

# install aws cli v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
cd /tmp/
unzip awscliv2.zip
./aws/install -i /usr/local/aws-cli -b /usr/local/bin
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"
cat <<EOF > ~/.aws/config
[default]
region = us-east-1
output = json
EOF
cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = test
aws_secret_access_key = test
EOF

echo "alias aws='aws --endpoint-url=http://localhost:4566'" >> ~/.bashrc

# setup desktop

cat <<EOF > /tmp/vnc.html
<!DOCTYPE html>
<html>
<head>

    <!--
    noVNC example: lightweight example using minimal UI and features
    Copyright (C) 2012 Joel Martin
    Copyright (C) 2017 Samuel Mannehed for Cendio AB
    noVNC is licensed under the MPL 2.0 (see LICENSE.txt)
    This file is licensed under the 2-Clause BSD license (see LICENSE.txt).

    Connect parameters are provided in query string:
        http://example.com/?host=HOST&port=PORT&encrypt=1
    or the fragment:
        http://example.com/#host=HOST&port=PORT&encrypt=1
    -->
    <title>Remote Desktop</title>

    <meta charset="utf-8">

    <!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame
                Remove this if you use the .htaccess -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <!-- Icons (see Makefile for what the sizes are for) -->
    <link rel="icon" sizes="16x16" type="image/png" href="app/images/icons/novnc-16x16.png">
    <link rel="icon" sizes="24x24" type="image/png" href="app/images/icons/novnc-24x24.png">
    <link rel="icon" sizes="32x32" type="image/png" href="app/images/icons/novnc-32x32.png">
    <link rel="icon" sizes="48x48" type="image/png" href="app/images/icons/novnc-48x48.png">
    <link rel="icon" sizes="60x60" type="image/png" href="app/images/icons/novnc-60x60.png">
    <link rel="icon" sizes="64x64" type="image/png" href="app/images/icons/novnc-64x64.png">
    <link rel="icon" sizes="72x72" type="image/png" href="app/images/icons/novnc-72x72.png">
    <link rel="icon" sizes="76x76" type="image/png" href="app/images/icons/novnc-76x76.png">
    <link rel="icon" sizes="96x96" type="image/png" href="app/images/icons/novnc-96x96.png">
    <link rel="icon" sizes="120x120" type="image/png" href="app/images/icons/novnc-120x120.png">
    <link rel="icon" sizes="144x144" type="image/png" href="app/images/icons/novnc-144x144.png">
    <link rel="icon" sizes="152x152" type="image/png" href="app/images/icons/novnc-152x152.png">
    <link rel="icon" sizes="192x192" type="image/png" href="app/images/icons/novnc-192x192.png">
    <!-- Firefox currently mishandles SVG, see #1419039
    <link rel="icon" sizes="any" type="image/svg+xml" href="app/images/icons/novnc-icon.svg">
    -->
    <!-- Repeated last so that legacy handling will pick this -->
    <link rel="icon" sizes="16x16" type="image/png" href="app/images/icons/novnc-16x16.png">

    <!-- Apple iOS Safari settings -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <!-- Home Screen Icons (favourites and bookmarks use the normal icons) -->
    <link rel="apple-touch-icon" sizes="60x60" type="image/png" href="app/images/icons/novnc-60x60.png">
    <link rel="apple-touch-icon" sizes="76x76" type="image/png" href="app/images/icons/novnc-76x76.png">
    <link rel="apple-touch-icon" sizes="120x120" type="image/png" href="app/images/icons/novnc-120x120.png">
    <link rel="apple-touch-icon" sizes="152x152" type="image/png" href="app/images/icons/novnc-152x152.png">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="app/styles/lite.css">

     <!--
    <script type='text/javascript'
        src='http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js'></script>
    -->

    <style>
        #noVNC_status_bar {
            display: none !important;
        }
    </style>

    <!-- promise polyfills promises for IE11 -->
    <script src="vendor/promise.js"></script>
    <!-- ES2015/ES6 modules polyfill -->
    <script type="module">
        window._noVNC_has_module_support = true;
    </script>
    <script>
        window.addEventListener("load", function() {
            if (window._noVNC_has_module_support) return;
            var loader = document.createElement("script");
            loader.src = "vendor/browser-es-module-loader/dist/browser-es-module-loader.js";
            document.head.appendChild(loader);
        });
    </script>

    <!-- actual script modules -->
    <script type="module" crossorigin="anonymous">
        // Load supporting scripts
        import * as WebUtil from './app/webutil.js';
        import RFB from './core/rfb.js';

        var rfb;
        var desktopName;

        function updateDesktopName(e) {
            desktopName = e.detail.name;
        }
        function credentials(e) {
            var html;

            var form = document.createElement('form');
            form.innerHTML = '<label></label>';
            form.innerHTML += '<input type=password size=10 id="password_input">';
            form.onsubmit = setPassword;

            // bypass status() because it sets text content
            document.getElementById('noVNC_status_bar').setAttribute("class", "noVNC_status_warn");
            document.getElementById('noVNC_status').innerHTML = '';
            document.getElementById('noVNC_status').appendChild(form);
            document.getElementById('noVNC_status').querySelector('label').textContent = 'Password Required: ';
        }
        function setPassword() {
            rfb.sendCredentials({ password: document.getElementById('password_input').value });
            return false;
        }
        function sendCtrlAltDel() {
            rfb.sendCtrlAltDel();
            return false;
        }
        function machineShutdown() {
            rfb.machineShutdown();
            return false;
        }
        function machineReboot() {
            rfb.machineReboot();
            return false;
        }
        function machineReset() {
            rfb.machineReset();
            return false;
        }
        function status(text, level) {
            switch (level) {
                case 'normal':
                case 'warn':
                case 'error':
                    break;
                default:
                    level = "warn";
            }
            document.getElementById('noVNC_status_bar').className = "noVNC_status_" + level;
            document.getElementById('noVNC_status').textContent = text;
        }

        function connected(e) {
            document.getElementById('sendCtrlAltDelButton').disabled = false;
            if (WebUtil.getConfigVar('encrypt',
                                     (window.location.protocol === "https:"))) {
                status("Connected (encrypted) to " + desktopName, "normal");
            } else {
                status("Connected (unencrypted) to " + desktopName, "normal");
            }
        }

        function disconnected(e) {
            document.getElementById('sendCtrlAltDelButton').disabled = true;
            updatePowerButtons();
            if (e.detail.clean) {
                status("Disconnected", "normal");
            } else {
                status("Something went wrong, connection is closed", "error");
            }
        }

        function updatePowerButtons() {
            var powerbuttons;
            powerbuttons = document.getElementById('noVNC_power_buttons');
            if (rfb.capabilities.power) {
                powerbuttons.className= "noVNC_shown";
            } else {
                powerbuttons.className = "noVNC_hidden";
            }
        }

        document.getElementById('sendCtrlAltDelButton').onclick = sendCtrlAltDel;
        document.getElementById('machineShutdownButton').onclick = machineShutdown;
        document.getElementById('machineRebootButton').onclick = machineReboot;
        document.getElementById('machineResetButton').onclick = machineReset;

        WebUtil.init_logging(WebUtil.getConfigVar('logging', 'warn'));
        document.title = WebUtil.getConfigVar('title', 'Remote Desktop');
        // By default, use the host and port of server that served this file
        var host = WebUtil.getConfigVar('host', window.location.hostname);
        var port = WebUtil.getConfigVar('port', window.location.port);

        // if port == 80 (or 443) then it won't be present and should be
        // set manually
        if (!port) {
            if (window.location.protocol.substring(0,5) == 'https') {
                port = 443;
            }
            else if (window.location.protocol.substring(0,4) == 'http') {
                port = 80;
            }
        }

        var password = WebUtil.getConfigVar('password', '');
        var path = WebUtil.getConfigVar('path', 'websockify');

        // If a token variable is passed in, set the parameter in a cookie.
        // This is used by nova-novncproxy.
        var token = WebUtil.getConfigVar('token', null);
        if (token) {
            // if token is already present in the path we should use it
            path = WebUtil.injectParamIfMissing(path, "token", token);

            WebUtil.createCookie('token', token, 1)
        }

        (function() {

            status("Connecting", "normal");

            if ((!host) || (!port)) {
                status('Must specify host and port in URL', 'error');
            }

            var url;

            if (WebUtil.getConfigVar('encrypt',
                                     (window.location.protocol === "https:"))) {
                url = 'wss';
            } else {
                url = 'ws';
            }

            url += '://' + host;
            if(port) {
                url += ':' + port;
            }
            url += '/' + path;

            rfb = new RFB(document.body, url,
                          { repeaterID: WebUtil.getConfigVar('repeaterID', ''),
                            shared: WebUtil.getConfigVar('shared', true),
                            credentials: { password: password } });
            rfb.viewOnly = WebUtil.getConfigVar('view_only', false);
            rfb.addEventListener("connect",  connected);
            rfb.addEventListener("disconnect", disconnected);
            rfb.addEventListener("capabilities", function () { updatePowerButtons(); });
            rfb.addEventListener("credentialsrequired", credentials);
            rfb.addEventListener("desktopname", updateDesktopName);
            rfb.scaleViewport = WebUtil.getConfigVar('scale', false);
            rfb.resizeSession = WebUtil.getConfigVar('resize', true);
        })();
    </script>
</head>

<body>
  <div id="noVNC_status_bar">
    <div id="noVNC_left_dummy_elem"></div>
    <div id="noVNC_status">Loading</div>
    <div id="noVNC_buttons">
      <input type=button value="Send CtrlAltDel"
             id="sendCtrlAltDelButton" class="noVNC_shown">
      <span id="noVNC_power_buttons" class="noVNC_hidden">
        <input type=button value="Shutdown"
               id="machineShutdownButton">
        <input type=button value="Reboot"
               id="machineRebootButton">
        <input type=button value="Reset"
               id="machineResetButton">
      </span>
    </div>
  </div>
</body>
EOF

export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y xfce4 tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer novnc python3-websockify python3-numpy firefox

mkdir ~/.vnc

cat <<EOF > ~/.vnc/xstartup
#!/bin/bash

PATH=$PATH:/usr/bin:/usr/sbin:/usr/local/bin
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4 &
EOF

cp /tmp/vnc.html /usr/share/novnc/vnc.html

sudo vncserver -localhost no -SecurityTypes None --I-KNOW-THIS-IS-INSECURE
websockify -D --web=/usr/share/novnc 9999 localhost:5901


# vscode shortcut
cat << EOF > /root/Desktop/VisualStudioCode.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=VisualStudioCode
Comment=Code Editing. Redefined.
Exec=/usr/share/code/code %F --no-sandbox --user-data-dir=/tmp/vscode
Icon=vscode
Path=
Terminal=false
StartupNotify=false
EOF
chmod +x /root/Desktop/VisualStudioCode.desktop

cd 
bash

# Done
echo "Done" > /tmp/setup/done.txt
