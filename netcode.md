# References

[Unreal Engine Netcode](https://docs.google.com/document/d/1KGLbEfHsWANTTgUqfK6rkpFYDGvnZYj-BN18sxq6LPY/edit) (it's about UE1, not UE2.5 as the text implies)

# Trading

Sometimes two players fighting each other with hitscan weapons will kill each other. This is referred to as trading. Trading was introduced to IG+ to paper over client-side hitsounds making it obvious how often players with high pings would shoot a low-ping player without getting the kill. Trading fundamentally is fair because each player got the kill first from their perspective, however it is one of three possible solutions.

There are three goals of conflict resolution:

1) Responsiveness (players want to be notified of their kills ASAP)
2) Timeline consistency (killing each other with hitscan weapons should intuitively be impossible)
3) Ping compensation (you should get legitimate kills, no matter your ping)

Fulfilling all three perfectly at the same time is impossible, an engineering trade-off has to be found that is acceptable.

Sacrificing responsiveness is the worst option of the three, in my opinion. It is possible to implement by not applying shots immediately and instead waiting until the attacked player has sent an update indicating no shot was fired in time. This either delays kill notifications for a significant amount of time, or alternatively sacrifices ping compensation as well by imposing a low maximum amount of time to wait.

Sacrificing ping compensation is the default implementation. Here all shots are applied in the order they arrive at the server. A high-ping player will much more often not be the first to shoot, leaving those players at a disadvantage. This is an acceptable choice if players are never expected to play on servers where their pings are above, say, 80 milliseconds. Even then, a higher ping always gives you a disadvantage.

Sacrificing timeline consistency is what trading does. It allows both players killing each other because both shot and hit on their screen before dying themselves.

The current iteration of trading in IG+ is a hybrid of two approaches. When two players shoot each other at the same time, the server always applies the one that reached it first, and maybe also applies the second, if it determines that the second shot actually happened before the first by in-game-time if the ping of the shooter of the second shot is accounted for. In addition there is a limit on the time after death within which shots will still be processed.

# Extrapolation

A player's bad connection doesnt just drop packets, it also slows some packets down (usually right before or after dropped packets), resulting in a large discrepancy between the time since the last update was received by the server and the time-delta the packet is supposed to cover.

The server has to move every player along for roughly the amount of time that has passed since the last update for the player. If the server doesnt do that, it sends an outdated position to the clients. Meanwhile the clients have extrapolated the players position from their last known acceleration and velocity. So now the server sends outdated position data for that player to all clients, which causes the player to warp on all clients.

Extrapolating movement server-side when a player sends outdated position and movement data is the main way to prevent visible warping.

Another way of preventing warping is to ensure players dont have control over an unbounded amount of time in which their movement can diverge significantly from what all observing clients are extrapolating. This is achieved by letting the server generate movement updates if the client hasnt sent one within a certain amount of time.