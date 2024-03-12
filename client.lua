core = {
    start = function()
        local object = Resource.getFromName(OBJECT_PREVIEW)

        if not (object and object.state == 'running') then
            outputDebugString('Object preview resource not found')
            return
        end

        Object = exports[object.name]

        generate.events.start()
    end
}

generate = {
    index = false,
    object = false,
    vehicle = false,

    events = {
        start = function()
            generate.system.generate()
        end,
    },

    system = {
        generate = function()
            if not generate.index then
                generate.index = 1
            end

            local datas = VEHICLES[generate.index]

            if generate.object then
                Object:destroyObjectPreview(generate.object)
            end

            if generate.vehicle then
                generate.vehicle:destroy()
            end

            generate.vehicle = Vehicle(datas.model, 0, 0, 0)
            generate.vehicle:setColor(unpack(datas.color))

            generate.object = Object:createObjectPreview(generate.vehicle, 0, 0, 0, 0, 0, datas.size.w, datas.size.h)

            Object:setPositionOffsets(generate.object, datas.offset[1], datas.offset[2], datas.offset[3])
            Object:setRotation(generate.object, datas.rotation[1], datas.rotation[2], datas.rotation[3])

            Timer(function()
                -- local result = generate.system.capture(datas.model)
                local result = Object:saveRTToFile(generate.object, 'images/' .. datas.model .. '.png')

                if result then
                    generate.index = generate.index + 1

                    if generate.index > #VEHICLES then
                        Object:destroyObjectPreview(generate.object)
                        generate.vehicle:destroy()

                        return
                    end

                    generate.system.generate()
                else
                    outputDebugString('Failed to capture image for ' .. datas.model .. ' vehicle.')
                end
            end, 250, 1)
        end,

        capture = function(model)
            local pixels = dxConvertPixels(Object:getRenderTarget():getPixels(), 'png')

            local file = File('images/' .. model .. '.png')
            file:write(pixels)
            file:close()

            return File.exists('images/' .. model .. '.png')
        end
    },
}

addEventHandler('onClientResourceStart', resourceRoot, core.start)