# ElixirRoots: Growing Sustainable Practices with Rusty Prunes
[Work Music used during the project](https://on.soundcloud.com/G1pyG)

This project aims to develop a backend system using Elixir for a Content Delivery Network (CDN) and AI-assisted ecological reflexions for the frontend. The CDN will be responsible for efficiently delivering content to users, while the AI component will provide insights and suggestions for more sustainable and eco-friendly practices.

## Authors

- [@joxcat](https://www.github.com/joxcat)
- [@julien-cpsn](https://www.github.com/Julien-cpsn)

## Subjects choosen for this part
- https://www.nuitdelinfo.com/inscription/defis/388
- https://www.nuitdelinfo.com/inscription/defis/422

## Features

- [x] Image CDN
- [ ] Video CDN
- [ ] Generation of ecological facts based on real facts and numbers

## Tech Stack

**Server:** [Elixir](https://elixir-lang.org/), [Phoenix](https://www.phoenixframework.org/)  

**File Hash:** [Blake3](https://github.com/BLAKE3-team/BLAKE3/)  

**Tools:** [ffmpeg](https://ffmpeg.org/), [mogrify](https://imagemagick.org/script/mogrify.php)

## Deployment

To run this project execute

### CLI

```bash
mix setup # install and setup dependencies
mix phx.server # start Phoenix endpoint
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## API Reference

#### Upload image to CDN

```http
  POST /cdn/images (multipart/form-data)
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
|  `file`   | `upload` | **Required**. Your file to upload |

##### Returns
```json
{"filename":"<file name>","hash":"<blake3 hash>"}
```

#### Get optimized image from CDN (cached) by name

```http
  GET /cdn/images/:name?max_size= (E.G test.jpg)
```

| Parameter   | Type     | Description                       |
| :---------- | :------- | :-------------------------------- |
|  `name`     | `string` | **Required**. Your file name      |
|  `max_size` | `string` | The max size the file must be     |

#### Get optimized image from CDN (cached) by hash (blake3)

```http
  GET /cdn/images/by-hash/:hash?max_size=
```

| Parameter   | Type     | Description                       |
| :---------- | :------- | :-------------------------------- |
|  `hash`     | `string` | **Required**. Your file hash      |
|  `max_size` | `string` | The max size the file must be     |

## License

[MIT](./LICENSE)