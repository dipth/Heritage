require 'spec_helper'

describe BlogPost do
  let(:blog_post) { Factory(:blog_post) }
  
  it "should inherit title attribute" do
    blog_post.should respond_to :title
  end
  
  it "should inherit exposed methods" do
    blog_post.should respond_to :hello
  end
  
  it "should not inherit non-exposed methods" do
    blog_post.should_not respond_to :hidden_hello
  end
end
