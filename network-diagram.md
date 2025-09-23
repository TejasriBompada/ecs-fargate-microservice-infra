graph TB
    %% Colors
    classDef subnet fill:#D5F5E3,stroke:#27AE60,stroke-width:2px;
    classDef ecs fill:#FCF3CF,stroke:#F1C40F,stroke-width:2px;
    classDef sg fill:#FADBD8,stroke:#C0392B,stroke-width:2px;
    classDef alb fill:#E8DAEF,stroke:#8E44AD,stroke-width:2px;
    classDef nat fill:#FDEBD0,stroke:#E67E22,stroke-width:2px;
    classDef igw fill:#D5DBDB,stroke:#7F8C8D,stroke-width:2px;

    %% External
    Internet["Internet"]:::igw

    %% VPC as container
    subgraph VPC["VPC: dev-vpc"]
        %% Public Subnets
        subgraph "Public Subnets"
            pub_sub1["Public Subnet (us-east-1a)"]:::subnet
            pub_sub2["Public Subnet (us-east-1b)"]:::subnet
            alb["Application Load Balancer"]:::alb
            nat_gw["NAT Gateway"]:::nat
            igw["Internet Gateway"]:::igw
        end

        %% Private Subnets
        subgraph "Private Subnets"
            priv_sub1["Private Subnet (us-east-1a)"]:::subnet
            priv_sub2["Private Subnet (us-east-1b)"]:::subnet
            cluster["ECS Cluster"]:::ecs
            service["ECS Service"]:::ecs
            task["Running Task - Fargate"]:::ecs
        end

        %% Security Groups
        sg_pub["ALB SG"]:::sg
        sg_priv["ECS Task SG"]:::sg
    end

    %% Style the VPC container
    style VPC fill:#D6EAF8,stroke:#2980B9,stroke-width:2px;

    %% Traffic flow
    Internet --> igw
    igw --> pub_sub1
    igw --> pub_sub2
    pub_sub1 --> alb
    pub_sub2 --> alb
    alb --> task
    task --> priv_sub1
    priv_sub1 --> nat_gw
    priv_sub2 --> nat_gw
    nat_gw --> Internet

    %% ECS hierarchy
    cluster --> service
    service --> task

    %% Security group associations (dashed lines)
    alb -.-> sg_pub
    task -.-> sg_priv