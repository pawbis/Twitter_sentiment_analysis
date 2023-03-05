The Idea of this „project” was to get hands-on on different DevOps tools, to get idea of how they’re working. The Idea was simple, to create a containerized environment simulating microservice infrastructure, where different components are working together but separately. Idea was to fetch the twitter data, analyze it and visualize it. In order to achieve that I created 3 types of containers one for each task. In this project I’m not digging deep into python code, how the sentiment analysis is happening etc, I’m focused only on infrastructure. 

I.	Docker

Regarding infrastructure the base of this project is docker and containers. I’ve written simple images which are performing python scripts to achieve certain status. This means to fetch twitter data (twitter_api), clean the data and perform sentiment analysis (api_analysis), and “visualize” it via jupyter notebook (visualization). First container saved the data to the mounted volume, second one reads it, perform necessary analysis and saves the results, and third one reads it and visualizes. Later, working images were uploaded on docker hub.
![dockerhub](https://user-images.githubusercontent.com/89453589/222973342-d5e60b6b-7801-4b48-bb85-adca74b98591.png)

II.	Kubernetes

Second tool which I look into was Kubernetes. With the base I had (docker images), I decided to achieve the same result but using different tool. Other than that I wanted to test different features of Kubernetes like rolling update, scaling etc. I wrote 3 deployment files, where I fetched the adequate images from docker hub. More than I’ve created persistent volume and adequately claimed enough space for each of the pods to be working correctly. Also I created load balancer so that traffic is being send to visualization pod. That was done internally using minikube tunnel. 

III.	Helm & Argo CD.

The next tool which I picked up was Argo CD, I wanted to try out some of the CI/CD available tools, which are important in CI/CD practices. Continuation of Kubernetes file were helm charts, later those charts were uploaded to ArgoCD. Here the deployment with adequate services were deployed and up and running.
![argocd](https://user-images.githubusercontent.com/89453589/222973351-2094272a-42e1-4801-85dd-716f17160d58.PNG)

IV.	Jenkins.

I had to try Jenkins as it is the most popular CI/CD out there. I’ve built simple pipeline which tried to run those 3 docker images. Unfortunately for containers which are being exited after the code is performed, the pipeline is being stopped. As we can see on the screenshot, visualization container which is running constantly jupyter notebook is fine, when the same code produces error for api container. I have few ideas how to get this working in the future.
![jenkins](https://user-images.githubusercontent.com/89453589/222973356-f1f34f86-2f72-42c0-b9a7-9a0a08843be3.PNG)

V.	 Terraform 

Next tool was terraform. I had an Idea to deploy those containers into AWS EKS, but unfortunately for free tier EKS is not available for free as far as I know. To get the grasp of what terraform is being used for I decided to order EC2 instance with S3 storage with all the necessary stuff around it (aws roles, policies, instance profiles, aws vpc, subnets, s3 acl, network interfaces).

VI.	Ansible

One of the tools that also are important considering infrastructure is Ansible. Using Vagrant I did created 4 Vm’s (1 master, 3 hosts) to perform ansible tests. Before using ansible I did set the network connection so that the VM’s are able to ssh themselves and communicate. In first Ansible script I Did install Docker on all of the host machines. Later using second script I did pull adequate docker images and tried to run them. Running them wasn’t successful due to them not having external volume where they can store files. Lets say if I were to perform this steps in AWS, all of these vm’s would have access to s3 storage where they could store the files and work properly.
