# rufus-daemon

Run a rufus-scheduler daemon in the background, with access to the instance over DRb unix socket.
Lovingly built to prevent hanging processes.

## Why?
1. Get status updates on your jobs
2. Build a job querying service
3. Allow other processes to dynamically schedule jobs
4. Organise schedule files in ~/.rufus
5. ???
6. Profit

## Install
```ruby
gem install rufus-daemon
```

## Usage

### Running the command line
```bash
$ rufus --help
Usage: rufus [options]

Example: rufus --start

Options:
        --start
        --restart
        --stop
        --status
        --list

Help options:
        --help
```

### Access the rufus instance over DRb socket
```ruby
require 'rufus/daemon'

Rufus::Daemon.attach.then do |service|
  puts service.rufus # the rufus-scheduler instance

  # .jobs is a helper that deserializes the jobs before sending
  # over DRb socket. Otherwise you get a marshalling error.
  service.jobs.each do |job|
    puts job
  end
end
```

###
The daemon will load both a `~/rufus.rb` file, and all files inside `~/.rufus` with the glob  `~/.rufus/**/*.rb`.
Here's what your files can look like.
```
every '10s' do
  # call something
end

cron '0 9 * * *' do
  # call something
end
```



## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
