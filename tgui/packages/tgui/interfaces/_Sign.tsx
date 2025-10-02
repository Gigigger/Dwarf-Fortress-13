import { Button, Section, Stack, TextArea } from 'tgui-core/components';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

const DecalList1 = (props) => {
  const { act, data } = useBackend();
  const { decals, current_decal, selected_decal_1 } = data as any;
  const { selectable_decals, decal_num } = props;

  return (
    <Section fill scrollable>
      {selectable_decals.map(entry => (
        <Button
          key={entry}
          tooltip={entry}
          content={entry}
          selected={entry === selected_decal_1}
          onClick={() => act('set_decal_1', {
            selected_decal_1: entry,
          })}
        />
      ))}
    </Section>
  );
};

const DecalList2 = (props) => {
  const { act, data } = useBackend();
  const { decals, current_decal, selected_decal_2 } = data as any;
  const { selectable_decals, decal_num } = props;

  return (
    <Section fill scrollable>
      {selectable_decals.map(entry => (
        <Button
          key={entry}
          tooltip={entry}
          content={entry}
          selected={entry === selected_decal_2}
          onClick={() => act('set_decal_2', {
            selected_decal_2: entry,
          })}
        />
      ))}
    </Section>
  );
};


export const _Sign = (props) => {
  const { act, data } = useBackend();
  const {
    decals,
    current_decal,
    selected_decal,
    selected_decal_1,
    text,
  } = data as any;
  const [new_text, setText] = useLocalState('new_text', '');
  return (
    <Window theme="dwarf"
      width={650}
      height={415}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <TextArea
              height="200px"
              mb={1}
              fluid
              autoFocus
              placeholder="Text"
              value={text}
              onInput={(e, value) => setText(value)} />
          </Stack.Item>
          <Stack.Item mt={0} grow={1} basis={0}>
            <DecalList1
              selectable_decals={decals}
            />
          </Stack.Item>
          <Stack.Item mt={0} grow={1} basis={0}>
            <DecalList2
              selectable_decals={decals}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="pick color"
              tooltip="Pick color"
              onClick={() => act('pick_color', {
              })}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Write!"
              tooltip="Write!"
              onClick={() => act('write', {
                text: new_text,
              })}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );


};
