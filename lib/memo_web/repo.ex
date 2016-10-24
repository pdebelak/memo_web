defmodule MemoWeb.Repo do
  use Ecto.Repo, otp_app: :memo_web
  use Scrivener, page_size: 10
end
