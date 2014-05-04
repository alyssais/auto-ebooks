require "#{Rails.root}/config/environment"

namespace :bots do
  desc "Runs the bots"
  task :run do
    EM.run do
      def run_new_accounts
        p Account.all.map(&:bot).reject(&:running).each(&:start)
      end

      Rufus::Scheduler.new.every '1m' do
        run_new_accounts
      end

      run_new_accounts
    end
  end
end
