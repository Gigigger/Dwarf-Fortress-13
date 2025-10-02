import { Button } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const _EmoteMenu = (props) => {
  const { act, data } = useBackend();
  const { emotes } = data as any;
  return (
    <Window
      theme="dwarf"
      width={490}
      height={385}>
      <Window.Content scrollable>
        {emotes
          .map((thing, index) => (
            <Button
              key={thing.name}
              width="90px"
              fontSize="11px"
              compact
              color={index%2 === 0 ? "brown" : "average"}
              content={thing.name}
              onClick={() => act(thing.name)} />
          ))}
      </Window.Content>
    </Window>
  );
};
