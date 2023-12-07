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

- CDN
- Generation of ecological facts based on real facts and numbers
## Tech Stack

**Server:** [Elixir](https://elixir-lang.org/), [Phoenix](https://www.phoenixframework.org/)

## Deployment

To run this project execute

### CLI

```bash
mix setup # install and setup dependencies
mix phx.server # start Phoenix endpoint
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### With Docker

## API Reference

#### Get all items

```http
  GET /api/items
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | **Required**. Your API key |


## License

[MIT](./LICENSE)