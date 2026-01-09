# frozen_string_literal: true

require 'drb/drb'
require 'fileutils'
require 'rufus-scheduler'

module Rufus
  class Daemon
    VERSION = "1.0.1"

    SOCKET_DIR = "/tmp/drb-sockets"
    SOCKET_FILE = SOCKET_DIR + "/rufus.sock"
    SOCKET_URI = "drbunix://#{SOCKET_FILE}"

    attr_reader :rufus

    def initialize
      @rufus = Rufus::Scheduler.new
      @drb = DRb.start_service(SOCKET_URI, self)
    end

    def uri = @drb.uri

    def load_schedule(path)
      @rufus.instance_eval(File.read(path))
    end

    def stop
      @rufus.shutdown
    ensure
      DRb.stop_service
    end

    def jobs
      @rufus.jobs.map do |job|
        {
          id: job.id,
          scheduled_at: job.scheduled_at.to_s,
          next_time: (job.next_time.to_s if job.respond_to?(:next_time)),
          last_time: (job.last_time.to_s if job.respond_to?(:last_time)),
          tags: job.tags,
          original: job.original
        }.compact
      end
    end

    def self.attach
      DRbObject.new_with_uri(SOCKET_URI)
    end

    def self.stop
      attach.stop
      puts "Rufus stopped"
    rescue DRb::DRbConnError
      puts "Already Stopped"
    end

    def self.start
      FileUtils.mkdir_p(SOCKET_DIR)

      fork do
        Process.setsid

        fork do
          daemon = new
          puts "Rufus started - #{daemon.uri}"
          DRb.thread.join
        rescue Errno::EADDRINUSE
          puts "Already started"
        end

        exit # closes the process after DRb ends
      end

      Process.wait # no idea what this does
    end
  end
end
