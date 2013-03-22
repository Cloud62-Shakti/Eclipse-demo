// Trigger runs getLocation() on Contact with no Geolocation
trigger SetContactGeolocation on Contact (after insert, after update) {
    for (Contact c : trigger.new)
        if (c.Location__Latitude__s == null)
            LocationCallouts.getLocation(c.id);
}