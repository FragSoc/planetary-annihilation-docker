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
`PA_STREAM_NAME` | `stable` | Build stream to download the server from. See [here](https://github.com/planetary-annihilation/papatcher/blob/master/papatcher.go#L245).
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

## Licensing

The few files in this repository are licensed under the [AGPL](https://www.gnu.org/licenses/agpl-3.0.en.html).

However, PA:T itself is licensed by [Planetary Annihilation Inc.](https://planetaryannihilation.com/news/planetary-annihilation-inc-the-future-of-pa-and-titans/).
No credit is taken for the software running in this container.
Read [their TOS](https://planetaryannihilation.com/terms/) for more information.
