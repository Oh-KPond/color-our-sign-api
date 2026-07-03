# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

- Ruby 2.5.0, Rails 5.2 (API-only mode)
- PostgreSQL
- `rufus-scheduler` for in-process job scheduling
- `rack-cors` (all origins allowed, GET/POST only)
- Tests: Minitest with `minitest-rails` and `minitest-reporters`

## Commands

```bash
bundle install       # install dependencies
rails s              # start server (default port 3000)
rails db:create      # create postgres databases
rails db:migrate     # run migrations
rails db:seed        # seed data
rails test           # run all tests
rails test test/controllers/queued_colors_controller_test.rb  # run a single test file
```

## Architecture

This is a JSON API backend for a physical LED sign that displays colors submitted by users.

**Color lifecycle:**
1. User POSTs a color to `POST /queued_colors` → stored in `queued_colors` table
2. When the first color is added to an empty queue, `QueuedColor.color_change` starts a `rufus-scheduler` job that fires every `DURATION_TIME` (10) seconds
3. Each scheduler tick: moves `QueuedColor.first` into `displayed_colors` (as a new `DisplayedColor`) and destroys it from the queue
4. Scheduler shuts itself down when the queue empties
5. `GET /color` — polled by the hardware — returns the first queued color, or falls back to `DisplayedColor.last` if the queue is empty

**Key detail:** `QueuedColor.color_change` stores the scheduler job in a class variable `@@job` to track last execution time for `countdown_time` calculation. This means the scheduler lives in the Rails process — not a separate worker — so it won't survive a dyno restart on Heroku.

**Routes:**
- `GET /queued_colors` — list all queued colors
- `POST /queued_colors` — enqueue a color (`{ color: "51, 51, 51" }`)
- `GET /color` — current color for hardware to display
- `GET /displayed_colors` — history of displayed colors (controller stub, not fully implemented)

## Deployment

Deployed on Heroku at `color-our-sign-api.herokuapp.com`. Review Apps are automatically created for each pull request (see `app.json`).

## Related Repos

- React frontend: [Oh-KPond/color-our-sign](https://github.com/Oh-KPond/color-our-sign)
- Hardware (Adafruit Feather): [Oh-KPond/color-our-sign-feather](https://github.com/Oh-KPond/color-our-sign-feather)
