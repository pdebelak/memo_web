defmodule MemoWeb.Repo do
  use Ecto.Repo, otp_app: :memo_web
  use Kerosene, per_page: 10
end
