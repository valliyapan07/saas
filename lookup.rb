def get_command_line_argument
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

domain = get_command_line_argument
dns_raw = File.readlines("zone.txt")

dns_records = Hash.new { }

def parse_dns(dns_raw, dns_records)
  arr = dns_raw.to_s.split("C")
  arr = dns_raw.to_s.split('\n')
  for i in 0...arr.length
    arr[i] = arr[i].delete('"[],')
    arr[i] = arr[i].strip
  end

  for i in 0...arr.length - 1
    x = arr[i].index(" ")
    y = arr[i].length - arr[i].reverse.index(" ") - 1
    dns_records.store(arr[i].slice(x + 1...y), arr[i].slice(y + 1...arr[i].length))
  end
  return dns_records
end

def resolve(dns_records, lookup_chain, domain)
  if dns_records.has_key?(domain)
    lookup_chain.push(dns_records[domain])
    if (/[:alpha:]/.match dns_records[domain])
      resolve(dns_records, lookup_chain, dns_records[domain])
    else
      return lookup_chain
    end
  else
    print "Error: record not found for #{domain}"
    exit
  end
end

dns_records = parse_dns(dns_raw, dns_records)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
