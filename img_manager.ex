defmodule ImgManager do
    def start() do
        path = IO.gets("Enter the path of the folder you want to manage : ")
        |> String.trim

        if File.exists?(path) and File.dir?(path) do
            File.cd(path)

            if !File.exists?("img"), do: File.mkdir("img")
            
            File.ls()
            |> Kernel.elem(1)
            |> Enum.each(fn x -> 
                if String.ends_with?(x, [".jpg", ".png", ".gif", ".bmp"]) do
                    File.cp(x, "./img/" <> x)
                    File.rm(x)
                end
            end)
        end
    end
end