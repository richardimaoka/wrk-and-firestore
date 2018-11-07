## Prerequisite

- Install Docker - https://docs.docker.com/install/#supported-platforms
- Install node and npm - https://nodejs.org/en/download/
- Install jq - https://stedolan.github.io/jq/download/

Create a Firebase project, and enable Cloud Firestore
- https://firebase.google.com
- https://firebase.google.com/products/firestore/

## Steps to run

- Install wrk - https://github.com/wg/wrk/wiki

- Download and save Firebase admin credentials to `ServiceAccountKey.json` following [this video's](https://www.youtube.com/watch?v=Z87OZtIYC_0&feature=youtu.be&t=128) instruction

- `npm init`

- `npm install --save firebase-admin`

- `docker run -d -p 8080:80 nginx:latest`

- `./wrk-and-firestore.sh -t 5 -c 10 -d 5 http://localhost:8080`

Then you will see output like below in stdout:

```
Running 5s test @ http://localhost:8080
  5 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.18ms    3.34ms  42.20ms   89.63%
    Req/Sec   787.84    168.66     1.09k    74.00%
  19666 requests in 5.02s, 15.94MB read
Requests/sec:   3918.81
Transfer/sec:      3.18MB
```

and see the following three files are craeted:

- result_intermediate.json
- result_metadata.json
- result.json

And the JSON from `result.json` is uploaded to your Cloud Firestore.
