defmodule MemoWeb.FormHelpers do
  use Phoenix.HTML

  def text_tag(form, field) do
    form_field_tag(form, field, :text_input)
  end

  def password_tag(form, field) do
    form_field_tag(form, field, :password_input)
  end

  def email_tag(form, field) do
    form_field_tag(form, field, :email_input)
  end

  def textarea_tag(form, field) do
    form_field_tag(form, field, :textarea, "textarea")
  end

  def submit_tag(text) do
    content_tag :div, class: "control" do
      submit text, class: "button is-primary"
    end
  end

  defp form_field_tag(form, field, input_method) do
    form_field_tag form, field, input_method, "input"
  end

  defp form_field_tag(form, field, input_method, input_class) do
    content_tag :div, class: "control" do
      label = label(form, field, class: "label")
      input = apply(Phoenix.HTML.Form, input_method, [form, field, [class: input_class(form, field, input_class)]])
      error = MemoWeb.ErrorHelpers.error_tag(form, field) || ""
      [label, input, error]
    end
  end

  defp input_class(form, field, input_class) do
    if form.errors[field] do
      "#{input_class} is-danger"
    else
      input_class
    end
  end
end
