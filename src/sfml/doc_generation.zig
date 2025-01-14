//! This thing is just a hack to get the documentation generation working

const sf = @import("sfml");

pub fn main() !void {
    inline for ([3]type{ sf.Vector2f, sf.Vector2i, sf.Vector2u }) |T| {
        var vecf = T{ .x = 0, .y = 0 };
        var c = vecf.toCSFML();
        vecf = T.fromCSFML(c);
        _ = vecf.add(vecf);
        _ = vecf.substract(vecf);
        _ = vecf.scale(1);
    }
    {
        var vecf = sf.Vector3f{ .x = 0, .y = 0, .z = 0 };
        var c = vecf.toCSFML();
        vecf = sf.Vector3f.fromCSFML(c);
    }
    {
        var col = sf.Color.fromRGB(0, 0, 0);
        col = sf.Color.fromRGBA(0, 0, 0, 0);
        col = sf.Color.fromInteger(0);
        col = sf.Color.fromHSVA(0, 0, 0, 0);
        var c = col.toCSFML();
        col = sf.Color.fromCSFML(c);
        _ = col.toInteger();

        col = sf.Color.Black;
        col = sf.Color.White;
        col = sf.Color.Red;
        col = sf.Color.Green;
        col = sf.Color.Blue;
        col = sf.Color.Yellow;
        col = sf.Color.Magenta;
        col = sf.Color.Cyan;
        col = sf.Color.Transparent;
    }
    {
        var clk = try sf.Clock.init();
        defer clk.deinit();
        _ = clk.restart();
        _ = clk.getElapsedTime();
    }
    {
        var tm = sf.Time.seconds(0);
        tm = sf.Time.milliseconds(0);
        tm = sf.Time.microseconds(0);
        var c = tm.toCSFML();
        tm = sf.Time.fromCSFML(c);
        _ = tm.asSeconds();
        _ = tm.asMilliseconds();
        _ = tm.asMicroseconds();
        sf.Time.sleep(sf.Time.Zero);
    }
    {
        var ts = sf.TimeSpan.init(sf.Time.Zero, sf.Time.seconds(1));
        var c = ts.toCSFML();
        ts = sf.TimeSpan.fromCSFML(c);
    }
    {
        _ = sf.Keyboard.isKeyPressed(.A);
    }
    {
        _ = sf.Mouse.isButtonPressed(.Left);
        _ = sf.Mouse.getPosition(null);
        sf.Mouse.setPosition(.{.x = 3, .y = 3}, null);
    }
    {
        var evt: sf.Event = undefined;
        evt.resized = .{.size = .{.x = 3, .y = 3}};
        _ = sf.Event.getEventCount();
    }
    {
        var mus = try sf.Music.initFromFile("");
        defer mus.deinit();
        mus.play();
        mus.pause();
        mus.stop();
        _ = mus.getDuration();
        _ = mus.getPlayingOffset();
        _ = mus.getLoopPoints();
        _ = mus.getLoop();
        _ = mus.getPitch();
        _ = mus.getVolume();
        mus.setVolume(1);
        mus.setPitch(1);
        mus.setLoop(true);
        mus.setLoopPoints(sf.TimeSpan.init(sf.Time.Zero, sf.Time.seconds(1)));
        mus.setPlayingOffset(sf.Time.Zero);
    }
    {
        var win = try sf.RenderWindow.init(.{.x = 0, .y = 0}, 0, "");
        defer win.deinit();
        defer win.close();
        _ = win.pollEvent();
        _ = win.isOpen();
        win.clear(sf.Color.Black);
        win.draw(@as(sf.CircleShape, undefined), null);
        win.display();
        _ = win.getView();
        _ = win.getDefaultView();
        _ = win.getSize();
        _ = win.getPosition();
        win.setView(@as(sf.View, undefined));
        win.setSize(.{ .x = 0, .y = 0 });
        win.setPosition(.{ .x = 0, .y = 0 });
        win.setTitle("");
        win.setFramerateLimit(0);
        win.setVerticalSyncEnabled(true);
        _ = win.mapPixelToCoords(.{ .x = 0, .y = 0 }, null);
        _ = win.mapCoordsToPixel(.{ .x = 0, .y = 0 }, null);
    }
    {
        var tex = try sf.Texture.init(.{ .x = 10, .y = 10});
        tex = try sf.Texture.initFromFile("");
        tex = try sf.Texture.initFromImage(@as(sf.Image, undefined), null);
        defer tex.deinit();
        _ = tex.get();
        tex.makeConst();
        _ = try tex.copy();
        _ = tex.getSize();
        _ = tex.getPixelCount();
        _ = try tex.updateFromPixels(@as([]const sf.Color, undefined), null);
        _ = tex.updateFromImage(@as(sf.Image, undefined), null);
        _ = tex.updateFromTexture(@as(sf.Texture, undefined), null);
        _ = tex.isSmooth();
        _ = tex.isRepeated();
        _ = tex.isSrgb();
        _ = tex.swap(@as(sf.Texture, undefined));
        tex.setSmooth(true);
        tex.setSrgb(true);
        tex.setRepeated(true);
    }
    {
        var img = try sf.Image.init(.{ .x = 10, .y = 10}, sf.Color.Red);
        img = try sf.Image.initFromFile("");
        img = try sf.Image.initFromPixels(.{ .x = 10, .y = 10}, @as([]const sf.Color, undefined));
        defer img.deinit();
        //var fct = sf.Image.getPixel;
        img.setPixel(.{ .x = 1, .y = 1}, sf.Color.Blue);
        _ = img.getSize();
    }
}
