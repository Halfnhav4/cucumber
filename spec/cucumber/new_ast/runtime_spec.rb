require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/parse_tree/step'
require 'cucumber/new_ast/runtime'
require 'cucumber/new_ast/compiled_step'
require 'cucumber/new_ast/compiled_hook'
require 'cucumber/step_mother'

module Cucumber
  module NewAst
    describe Runtime do
      before do
        @step_mother = StepMother.new
        @rb = @step_mother.load_programming_language('rb')
        @runtime = Runtime.new
      end

      it "should invoke a step definition" do
        step = ParseTree::Step.new("Given", "I have 5 cukes in my belly", 9)
        matched_cukes = nil
        @rb.register_rb_step_definition(/I have (.*) cukes in my belly/, lambda {|cukes| matched_cukes = cukes})
        ast_step = NewAst::CompiledStep.new(step, @step_mother.step_match(step.name, step.name))
        @runtime.visit(ast_step)
        matched_cukes.should == "5"
      end

      it "should invoke a before hook" do
      #  pending("******************* Next place to pick up, Aslak!") do
          kilroy = nil
          hook = @rb.register_rb_hook(:before, [], lambda {kilroy = "was here"})
          ast_hook = NewAst::CompiledHook.new(hook, @step_mother)
          @runtime.visit(ast_hook)
          kilroy.should == "was here"
      #  end
      end
    end
  end
end
