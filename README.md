# DockerRocker

This gem provides an executable `rocker` that kind of extends the `docker` executable.

So far, the only command implemented is `rocker build` which runs a preprocessor on a Dockerfile before building it.

## Example

Given the Dockerfiles:

```
# Dockerfile-base
SADD :postgresql_tar /tmp/pg-src
RUN cd /tmp/pg-src && ./configure && make && make install
```

```Dockerfile-9.2.4
SET :postgresql_tar postgresql-9.2.4.tar.gz
INCLUDE Dockerfile-base
```

Then running

```
rocker build -f Dockerfile-9.2.4
```

Will generate a temporary Dockefile and run `docker build` on it:

```
# Temporary Dockerfile
COPY postgresql-9.2.4.tar.gz /tmp/
RUN mkdir #{dst}
RUN tar xzf /tmp/postgresql-9.2.4.tar.gz -C /tmp/pg-src --strip-components 1
```

Notice two things
1. There are new Dockerfile commands.
2. You can include Dockerfiles into other Dockerfiles.

Extensions to Dockerfile are done with plugins. In fact, all 3 of those commands `SET`, `INCLUDE`, and `SADD` are implemented via a DockerRocker plugin.

## Installation

It's best to install this gem "globally" via `gem install docker-rocker` so that the `rocker` executable is available everywhere. It saves you from having to `bundle exec rocker` everywhere and lets you use it in projects without a Gemfile.

Or you can install via Bundler and a Gemfile:

```ruby
# In Gemfile
gem "docker-rocker"
```

```sh
# In project dir
bundle install
```

But then you'll have to type `bundle exec rocker` all the time.

## Usage

### build

Run a preprocessor on Dockerfiles before building them.

#### Plugins

Add new instructions to Dockerfiles via plugins.  Plugins can be published as gems or exist as Ruby files on your filesystem.

A simple plugin that adds a new Dockerfile instruction.

```ruby
require "docker_rocker/build/plugin"

module MyDockerRockerPlugin
  include DockerRocker::Build::Plugin
  expand "FUN" do |line|
    <<-TEXT
    RUN echo 'what is fun?'
    RUN echo '#{line} is fun!'
    TEXT
  end
end
```

Then given a Dockerfile:

```
FROM ubuntu:14.04
FUN climbing
```

`docker build -F Dockerfile` will create a new Dockerfile and run `docker build` on it:

```
FROM ubuntu:14.04
RUN echo 'what is fun?'
RUN echo 'climbing is fun!'
```

#### Automatic tagging

`rocker build -f Dockerfile-suffix` will automatically tag images with `$USER/$PWD:suffix`.

You can turn off automatic tagging with `docker build --no-tag`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cjbottaro/docker-rocker.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
