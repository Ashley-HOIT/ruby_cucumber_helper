# a proxy server using WEBrick's HTTPProxy gem
# feel free to delete the proxy but remember to remove the references to this class
module Env
  class Env_setup

    include RSpec::Matchers

    attr_reader :port_num

    def initialize(options={})
      # finds a free listening port
      @port_num = %x(
                  lp=null\n
                  for port in $(seq 4444 4450); do\n
                  lsof -i -n -P |grep LISTEN |grep -q ":${port}"\n
                  [ $? -eq 1 ] && { lp=$port; break; }\n
                  done\n
                  [ "$lp" = "null" ] && { echo "no free local ports available"; return 2; }\n
                  echo $port\n)
      @port_num=@port_num.to_i
    end

    def create_proxy
      @my_proxy_server= WEBrick::HTTPProxyServer.new(:Port => @port_num)

      trap 'INT' do
        @my_proxy_server.shutdown
      end
      trap 'TERM' do
        @my_proxy_server.shutdown
      end

    end

    def start_proxy
      @pid = fork do
        @my_proxy_server.start
        system ('sleep 5')
      end
    end

    def exists?
      Process.kill(0, @pid)
    rescue Errno::ESRCH
      puts "####### App failed to start correctly #######"
      exit
    end

    def kill_proxy_app
      exec "kill -INT '#{@pid}'"
      system ('sleep 5')
    rescue Exception => e
      puts e
    end

  end

end
