require 'erb'

# HTMLテンプレートをレンダリングするメソッド
def render_template(template_name, locals = {})
    template_path = File.join(__dir__, '.././../views', "#{template_name}.html.erb")
    template = ERB.new(File.read(template_path))
    template.result_with_hash(locals)
end