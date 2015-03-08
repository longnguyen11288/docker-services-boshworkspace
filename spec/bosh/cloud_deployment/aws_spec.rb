require "bosh/cloud_deployment"
require "bosh/cloud_deployment/aws"

describe Bosh::CloudDeployment::AWS do
  subject { Bosh::CloudDeployment::AWS.new }
  it { expect(subject.cpi).to eq "aws" }
  describe "subnets" do
    before do
      cf_manifest = YAML.load_file(spec_asset("cf-aws-tiny.yml"))
      expect(subject).to receive(:get_deployment_manifest).with("cf").and_return(cf_manifest)
    end
    it "discovers subnets from CF manifest" do
      expect(subject.deployment_subnets("cf")).to eq(%w[subnet-5351d336 subnet-0061c177 subnet-5251d337])
    end
    it "subnet already being used" do
      expect(subject).to receive(:existing_deployment_names).and_return(["cf"])
      expect(subject.deployments_using_subnet("subnet-new")).to eq []
    end
    it "no deployments using subnet" do
      expect(subject).to receive(:existing_deployment_names).and_return(["cf"])
      expect(subject.deployments_using_subnet("subnet-5351d336")).to eq ["cf"]
    end
  end
end
