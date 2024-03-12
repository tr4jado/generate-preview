OBJECT_PREVIEW = 'object_preview' -- resource name

VEHICLES = {
    --[[ usage:
    {
        model = int, -- vehicle model
        size = {w = int, h = int}, -- width and height of the object preview,
        offset = {int, int, int}, -- x, y, z,
        rotation = {int, int, int} -- x, y, z
    },
    ]]

    {
        model = 579,
        size = {w = 488, h = 232},
        offset = {0.5, 0, 0},
        rotation = {-3, 0, 137},
        color = {255, 255, 255}
    }
}

addDebugHook('preFunction', function(resource, func)
    if not (resource.name == OBJECT_PREVIEW and func == 'outputDebugString') then
        return
    end

    return 'skip'
end)