<?php

namespace App\Events;

use App\Models\Announcement;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class AnnouncementCreated
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    /**
     * Create a new event instance.
     */
    public function __construct(Announcement $announcement)
    {
$this->announcement = $announcement;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, Channel>
     */
  public function broadcastOn(): array
    {
        $target = $this->announcement->target_audience; 
        $level  = $this->announcement->level;

        return [
            new Channel("announcements.{$target}.{$level}")
        ];
    }
public function broadcastAs(): string
    {
        return 'new-announcement';
    }
    public function broadcastWith(): array
    {
        return [
            'id'              => $this->announcement->id,
            'type'            => $this->announcement->type,
            'title'           => $this->announcement->title,
            'content'         => is_string($this->announcement->content) ? json_decode($this->announcement->content, true) ?: $this->announcement->content : $this->announcement->content,
            'target_audience' => $this->announcement->target_audience,
            'level'           => $this->announcement->level,
            'created_at'      => $this->announcement->created_at->toDateTimeString(),
        ];
    }





    }
