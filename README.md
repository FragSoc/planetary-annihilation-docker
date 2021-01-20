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
docker build -t pat .
docker run -d -p 20545:20545 pat
```

**Note:** *the UID of the user in the container defaults to `999`, pass `UID` as a build arg to change this*

### Ports

Port `20545` *must* be opened for client connections.

### Volumes

The container uses just one volume, to store replays: `/replays`.

**Note:** *if you use a [bind mount](https://docs.docker.com/storage/bind-mounts/), the host path you mount into the container *must* be owned by the UID you passed to the build (default `999`)*

## Licensing

The few files in this repository are licensed under the [GPL](https://www.gnu.org/licenses/gpl-3.0.en.html).

However, PA:T itself is licensed by [Planetary Annihilation Inc.](https://planetaryannihilation.com/news/planetary-annihilation-inc-the-future-of-pa-and-titans/).
No credit is taken for the software running in this container.
Read [their EULA](deadlink) for more information.
