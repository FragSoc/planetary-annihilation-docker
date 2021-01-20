<center>
    <a href="https://planetaryannihilation.com/">
        <img width=100% src="https://cdn.cloudflare.steamstatic.com/steam/apps/386070/header.jpg?t=1610497641"/>
    </a>
    <br/>
    <img alt="GitHub" src="https://img.shields.io/github/license/FragSoc/planetary-annihilation-titans-docker?style=flat-square">
</center>


---

A [docker](https://www.docker.com/) image for running a dedicated server for the game [Planetary Annihilation: Titans](https://planetaryannihilation.com/).

## Usage

An example sequence to build then run:

```bash
docker build \
    --build-arg PANET_USERNAME=<panet username> \
    --build-arg PANET_PASSWORD=<panet password> \
    -t pat .
docker run -d -p 20545:20545 pat
```

### Building

Build Arg Key | Default | Decription
---|---|---
`PA_STREAM_NAME` | `stable` | Build stream to download the server from. See [here](https://github.com/planetary-annihilation/papatcher/blob/master/papatcher.go#L245). Valid streams are `historical`, `legacy`, `legacy-pte`, `modern-pte`, `stable`.
`PANET_USERNAME` | N/A | Username to login to PANet with. Needs to own the game or be linked to a steam account which does. Required.
`PANET_PASSWORD` | N/A | Password for the provided username. Required.
`UID` | `999` | Unix UID to run the container as.

**Notes:**
- *the UID of the user in the container defaults to `999`, pass `UID` as a build arg to change this*
- *Credentials for the account are **not stored in the final image***.

### Running

Port `20545` *must* be opened for client connections.

The container uses just one volume, to store replays: `/replays`.

**Note:** *if you use a [bind mount](https://docs.docker.com/storage/bind-mounts/), the host path you mount into the container *must* be owned by the UID you passed to the build (see above table)*

#### Run Environment

The container can be completely customised with environment variables:

Var name | Default Value | Notes
---|---|---
`PA_TITANS_ENABLED` | yes | Any other value will disable the TITANS expansion on the server
`PA_AI_ENABLED` | yes | Any other value will disable AI players on the server
`PA_SERVER_NAME` | "A Dockerised PA:T Server" |
`PA_SERVER_PASSWORD` | "letmein" | Leave blank for no password
`PA_MAX_PLAYERS` | 12 |
`PA_MAX_SPECTATORS` | 5 |
`PA_SPECTATORS` | 5 |
`PA_REPLAY_TIMEOUT` | 180 |
`PA_GAMEOVER_TIMEOUT` | 360 |
`PA_EMPTY_TIMEOUT` | 3600 |

For more information, see the [official documentation](https://planetaryannihilation.com/guides/hosting-a-local-server/).

In addition, passing a command to the container will pass that command through to the server binary as a parameter, though passing a parameter that the container already runs (see the above list and `docker-entrypoint.sh`) may result in undefined behaviour.

## Licensing

The few files in this repository are licensed under the [AGPL](https://www.gnu.org/licenses/agpl-3.0.en.html).

However, PA:T itself is licensed by [Planetary Annihilation Inc.](https://planetaryannihilation.com/news/planetary-annihilation-inc-the-future-of-pa-and-titans/).
No credit is taken for the software running in this container.
Read [their TOS](https://planetaryannihilation.com/terms/) for more information.
