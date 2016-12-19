require 'yaml'
def resourcefact(type, spec)
	kernel = Facter.value(:kernel).downcase();
	case kernel
	when "windows"
		puppet_path = "puppet";
	else
		puppet_path = "/opt/puppetlabs/bin/puppet";
	end
	retval = nil;

	if (spec == [])
		resources = `#{puppet_path} resource #{type} --to_yaml --param provider`;
		begin   
			temp_resourcelist = YAML.load(resources);
		rescue  
			temp_resourcelist = nil;
		end
	else
		temp_resourcelist = {};
		result = {};
		spec.each do |value|
			spec_result = {};
			puppet_output = `#{puppet_path} resource #{type} #{value} --to_yaml --param provider`;
			begin   
				spec_result = YAML.load(puppet_output);
			rescue  
				spec_result = {};
			end
			result[value] = spec_result;
		end
		temp_resourcelist[type] = result;
	end

	unless (temp_resourcelist == nil)
		unless (temp_resourcelist == false)
			resourcelist = {};
			temp_resourcelist[type].each do |key, value|
				if value["provider"] == "systemd"
					resourcelist[key.gsub(".service", "")] = value;
				else
					resourcelist[key] = value;
				end
			end
			retval = resourcelist;
		end
	end
	return retval;
end
resources = {
	"service" => [],
	"yumrepo" => [],
	"user" => [],
	"package" => [],
	"host" => [],
	"cron" => [],
}
resources.each do |key, value|
	Facter.add("#{key}s") do
		setcode do
			resourcefact(key, value);
		end
	end
end

