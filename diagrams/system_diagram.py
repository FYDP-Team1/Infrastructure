from diagrams import Cluster, Diagram, Edge
from diagrams.custom import Custom
from diagrams.generic.os import Ubuntu
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.client import User
from diagrams.onprem.container import Docker
from diagrams.onprem.database import Postgresql
from diagrams.onprem.proxmox import ProxmoxVE
from diagrams.onprem.vcs import Github
from diagrams.programming.framework import React
from diagrams.programming.language import Nodejs, Python
from diagrams.saas.cdn import Cloudflare

with Diagram(
    "SimpleMeal System Diagram", "diagrams/system_diagram", show=False
) as diag:
    user = User("User")
    frontend = React("React\nSimpleMeal Frontend")

    github = Github("GitHub\nSimpleMeal Repo")
    actions = GithubActions("GitHub Action\nCI/CD")

    with Cluster("Infrastructure"):
        (
            ProxmoxVE("Proxmox VE\nServer")
            << Edge(color="royalblue", label="runs on")
            << Ubuntu("Ubuntu\nOperating System")
            << Edge(color="royalblue", label="runs on")
            << Docker("Docker")
        )

        with Cluster("Docker Containers"):
            cloudflared = Cloudflare("Cloudflare\nIngress")
            watchtower = Custom(
                "Watchtower\nContinuous Delivery", "./icons/watchtower.png"
            )

            pipeline = Python("Python\nData Pipeline")
            database = Postgresql("PostgreSQL\nDatabase")
            backend = Nodejs("Node.js\nSimpleMeal Backend")

    # Web application
    (
        user
        << Edge(color="darkorange")
        >> frontend
        << Edge(color="darkorange")
        >> cloudflared
        << Edge(color="darkorange")
        >> backend
    )
    database << Edge(color="darkorange") >> backend

    # Continuous Delivery
    (
        github
        >> Edge(color="royalblue", label="Code Updated")
        >> actions
        >> Edge(color="royalblue", label="Builds")
        >> cloudflared
        >> Edge(color="royalblue", label="Updates")
        >> watchtower
        >> Edge(color="royalblue", label="Updates")
        >> backend
    )

    # Data Pipeline
    food_com = Custom("Food.com\nrecipe source", "./icons/food_com.png")
    bluecart = Custom("Bluecart API\nprice source", "./icons/Bluecartapi-black.png")
    food_com >> Edge(color="firebrick") >> pipeline
    bluecart >> Edge(color="firebrick") >> pipeline
    pipeline >> Edge(color="firebrick", label="seed") >> database
