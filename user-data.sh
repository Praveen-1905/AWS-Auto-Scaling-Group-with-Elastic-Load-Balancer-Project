#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# Get this instance's metadata to display on the page
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
INSTANCE_TYPE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-type)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AWS Auto Scaling Demo</title>
<style>
  body {
    margin: 0;
    font-family: -apple-system, 'Segoe UI', Arial, sans-serif;
    background: linear-gradient(135deg, #1e3c72, #2a5298);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100vh;
  }
  .card {
    background: rgba(255,255,255,0.1);
    backdrop-filter: blur(10px);
    border-radius: 16px;
    padding: 40px 50px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.3);
    text-align: center;
    max-width: 480px;
  }
  h1 { font-size: 28px; margin-bottom: 8px; }
  p.subtitle { color: #cfd8ff; margin-top: 0; margin-bottom: 24px; }
  .row {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    border-bottom: 1px solid rgba(255,255,255,0.15);
    font-size: 15px;
  }
  .label { color: #cfd8ff; }
  .value { font-weight: 600; }
  .badge {
    display: inline-block;
    margin-top: 24px;
    padding: 6px 16px;
    background: #4ade80;
    color: #052e16;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
  }
</style>
</head>
<body>
  <div class="card">
    <h1>✅ Auto Scaling Group Live</h1>
    <p class="subtitle">Served via Elastic Load Balancer — refresh to see different instances</p>
    <div class="row"><span class="label">Instance ID</span><span class="value">$INSTANCE_ID</span></div>
    <div class="row"><span class="label">Availability Zone</span><span class="value">$AZ</span></div>
    <div class="row"><span class="label">Instance Type</span><span class="value">$INSTANCE_TYPE</span></div>
    <div class="badge">Healthy & Serving Traffic</div>
  </div>
</body>
</html>
EOF
