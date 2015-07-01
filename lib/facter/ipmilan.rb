Facter.add(:ipmiaddress) do
  confine :kernel => 'Linux'
  confine :is_virtual => [:false, false]

  output = Facter::Util::Resolution.exec("ipmitool lan print 1 2>/dev/null")
  attributes = {}
  output.each_line do |line|
    case line.strip
    when /^IP Address Source\s+: (.*)/
      attributes[:ipaddress_source] = $1
    when /^IP Address\s+: (.*)/
      attributes[:ipaddress] = $1
    when /^Subnet Mask\s+: (.*)/
      attributes[:subnet_mask] = $1
    when /^MAC Address\s+: (.*)/
      attributes[:macaddress] = $1
    when /^Default Gateway IP\s+: (.*)/
      attributes[:gateway] = $1
    end
  end if output

  if attributes.keys.empty?
    Facter.debug("Running ipmitool didn't give any information")
  end
  attributes[:enabled] = true
  attributes.each do |fact, value|
    Facter.add("ipmi_#{fact}") do
      confine :kernel => "Linux"
      setcode do
        value
      end
    end
  end

end


